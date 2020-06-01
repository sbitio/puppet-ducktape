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
    anchor {'jenkins-bootstrap-start': } ->
      Class['jenkins::cli_helper'] ->
      Exec[ducktape-jenkins-bootstrap-cliready] ->
      Exec[ducktape-jenkins-bootstrap-cmd] ->
    anchor {'jenkins-bootstrap-complete': }

    $initial_admin_pass_file = "/var/lib/jenkins/secrets/initialAdminPassword"
    Exec {
      unless => "test ! -e ${initial_admin_pass_file}",
    }

    $jenkins_cli = "/usr/bin/java -jar ${::jenkins::cli::jar} -s http://127.0.0.1:${jenkins::cli_helper::port} ${jenkins::cli_helper::prefix}"
    $jenkins_cli_auth_init ="/usr/bin/java -jar ${::jenkins::libdir}/jenkins-cli.jar -s http://127.0.0.1:8080 -auth admin:$(cat ${initial_admin_pass_file})"
    $puppet_helper = "/bin/cat ${::jenkins::libdir}/puppet_helper.groovy | ${jenkins_cli_auth_init} groovy ="

    if $admin_user == 'admin' {
      $remove_admin = "/bin/true"
    }
    else {
      $remove_admin = "${puppet_helper} delete_user admin"
    }

    exec { 'ducktape-jenkins-bootstrap-cliready':
      command => "${jenkins_cli_auth_init} who-am-i",
      tries => 15,
      try_sleep => 3,
    }
    exec { 'ducktape-jenkins-bootstrap-cmd':
      command => "${puppet_helper} set_security full_control \
        && ${puppet_helper} create_or_update_user '${admin_user}' '${admin_mail}' '${admin_pass}' '${admin_name}' '${admin_keys}' \
        && ${remove_admin} \
        && rm ${initial_admin_pass_file}",
      notify => Class['Jenkins::Cli::Reload'],
    }
  }

  if $enabled {
    include ducktape::jenkins::autoload
  }

}
