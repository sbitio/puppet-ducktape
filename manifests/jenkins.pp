class ducktape::jenkins (
  Boolean $bootstrap = true,
  Boolean $enabled   = true,
) {

  if $bootstrap {
    anchor {'jenkins-bootstrap-start': } ->
      Class['jenkins::cli_helper'] ->
      Exec[jenkins-ducktape-bootstrap-cliready] ->
      Exec[jenkins-ducktape-bootstrap-cmd] ->
    anchor {'jenkins-bootstrap-complete': }

    $jenkins_initial_admin_password_file = '/var/lib/jenkins/secrets/initialAdminPassword'
    $jenkins_cli = "${::jenkins::libdir}/jenkins-cli.jar"
    $jenkins_cli_authed ="/usr/bin/java -jar ${jenkins_cli} -s http://127.0.0.1:8080 -auth admin:$(cat $jenkins_initial_admin_password_file)"
    $puppet_helper = "/bin/cat ${::jenkins::libdir}/puppet_helper.groovy | ${jenkins_cli_authed} groovy ="
    if $::jenkins::cli_username == 'admin' {
      $remove_admin_if_necessary = "/bin/true"
    }
    else {
      $remove_admin_if_necessary = "${puppet_helper} delete_user admin"
    }
    $jenkins_cli_ready_cmd = "${jenkins_cli_authed} who-am-i"
    $jenkins_bootstrap_cmd = "${puppet_helper} set_security full_control && ${puppet_helper} create_or_update_user '${::jenkins::cli_username}' 'bootstrap@localhost' '${::jenkins::cli_password}' '${::jenkins::cli_username}' && ${remove_admin_if_necessary} && mv /var/lib/jenkins/secrets/initialAdminPassword /var/lib/jenkins/secrets/initialAdminPassword_back"
    exec { 'jenkins-ducktape-bootstrap-cliready':
      command => $jenkins_cli_ready_cmd,
      tries => 15,
      try_sleep => 3,
      onlyif => [ "test -f ${jenkins_initial_admin_password_file}" ],
    }
    exec { 'jenkins-ducktape-bootstrap-cmd':
      command => $jenkins_bootstrap_cmd,
      onlyif => [ "test -f ${jenkins_initial_admin_password_file}" ],
      notify => Class['Jenkins::Cli::Reload'],
    }
  }

  if $enabled {
    include ducktape::jenkins::autoload
  }

}
