class ducktape::jenkins::bootstrap (
  String  $admin_user = 'admin',
  String  $admin_pass = '',
  String  $admin_mail = 'root@localhost',
  String  $admin_name = $admin_user,
  String  $admin_keys = '',
  Boolean $create_password_file = false,
) {

  ### Create or update admin user
  $initial_admin_pass_file = "/var/lib/jenkins/secrets/initialAdminPassword"
  $jenkins_cli_auth_init ="/usr/local/bin/jenkins-cli -auth admin:$(cat ${initial_admin_pass_file})"
  $puppet_helper = "/bin/cat ${::jenkins::libdir}/puppet_helper.groovy | ${jenkins_cli_auth_init} groovy ="

  if $admin_user == 'admin' {
    $remove_admin = "/bin/true"
  }
  else {
    $remove_admin = "${puppet_helper} delete_user admin"
  }

  exec { 'ducktape-jenkins-bootstrap-cmd':
    command => "${puppet_helper} set_security full_control \
      && ${puppet_helper} create_or_update_user '${admin_user}' '${admin_mail}' '${admin_pass}' '${admin_name}' '${admin_keys}' \
      && ${remove_admin} \
      && rm ${initial_admin_pass_file}",
    require => Class['jenkins::cli_helper'],
    unless => "test ! -e ${initial_admin_pass_file}",
  }

  ### Generate a token for admin user and create password file used by jenkins-cli and puppet module
  if $create_password_file {
    if empty($::jenkins::cli::config::cli_password_file) {
      fail("ERROR: Unable to create password file for empty path. You must set jenkins::cli_password_file")
    }
    elsif ! $::jenkins::cli::config::cli_password_file_exists {
      fail("ERROR: Won't create a volatile password file. You must set jenkins::cli_password_file_exists to true")
    }
    else {
      # jenkins-cli groovy/groovysh doesn't return values.
      # So we "print" an OUTPUT and then parse it in a shell
      # to obtain the user:token pair and generate a file.
      $generate_token_script = "${::jenkins::libdir}/puppet_ducktape-generate_token.groovy"
      file {$generate_token_script:
        content  => epp('ducktape/jenkins/generate-token.groovy', {'admin_user' => $admin_user}),
        # Strictly speaking it should require the class that install te Jenkins package
        # But the class name is dynamic, derived from the module params. So here we keep it simple.
        require => Exec['ducktape-jenkins-bootstrap-cmd'],
      }
      exec { 'ducktape-jenkins-create-token':
        command => "/bin/cat $generate_token_script | /usr/local/bin/jenkins-cli -auth ${admin_user}:${admin_pass} groovysh 2>&1 | awk '/OUTPUT/ {print \$NF}' > ${::jenkins::cli_password_file}",
        umask => '0266',  # create the file with u+r permissions
        creates => $::jenkins::cli_password_file,
        require => [
          Exec['ducktape-jenkins-bootstrap-cmd'],
          File[$generate_token_script],
        ]
      }
    }
  }

}
