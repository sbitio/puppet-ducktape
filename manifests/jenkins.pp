class ducktape::jenkins (
  Boolean $enabled    = true,
  Boolean $bootstrap  = true,
) {

  if $enabled {
    ### Create wrapper for jenkins cli
    $jenkins_cli = "/usr/bin/java -jar ${::jenkins::cli::jar} -s http://127.0.0.1:${jenkins::cli_helper::port}${jenkins::cli_helper::prefix}"
    file {'/usr/local/bin/jenkins-cli':
      ensure => 'present',
      content  => epp('ducktape/jenkins/jenkins-cli', {'command' => $jenkins_cli, 'auth' => regsubst($::jenkins::_cli_auth_arg, "'", "", 'IG')}),
      mode => '0755',
    }

    if $bootstrap {
      include ducktape::jenkins::bootstrap
    }

    include ducktape::jenkins::autoload
  }

}
