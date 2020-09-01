class ducktape::jenkins (
  Boolean $bootstrap  = true,
  Boolean $enabled    = true,
  String  $admin_user = 'admin',
  String  $admin_pass = '',
  String  $admin_mail = 'root@localhost',
  String  $admin_name = $admin_user,
  String  $admin_keys = '',
) {

  if $bootstrap {
    anchor {'ducktape-jenkins-bootstrap-start': } ->
      Class['jenkins::cli_helper'] ->
      File['/usr/local/bin/jenkins-cli'] ->
      Exec[ducktape-jenkins-bootstrap-cmd] ->
    anchor {'ducktape-jenkins-bootstrap-complete': }

    ### Create wrapper for jenkins cli
    $jenkins_cli = "/usr/bin/java -jar ${::jenkins::cli::jar} -s http://127.0.0.1:${jenkins::cli_helper::port}${jenkins::cli_helper::prefix}"
    file {'/usr/local/bin/jenkins-cli':
      ensure => 'present',
      content  => epp('ducktape/jenkins/jenkins-cli', {'command' => $jenkins_cli, 'auth' => regsubst($::jenkins::_cli_auth_arg, "'", "", 'IG')}),
      mode => '0755',
    }

    ### Create or update admin user
    # Use jenkins-cli and add an additional -auth parameter for the initial setup.
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
      notify => Class['Jenkins::Cli::Reload'],
      unless => "test ! -e ${initial_admin_pass_file}",
    }
  }

  if $enabled {
    include ducktape::jenkins::autoload
  }
}
