class ducktape::jenkins (
  Boolean $enabled    = true,
  Boolean $bootstrap  = true,
  Hash    $cli_exec_defaults          = {},
  Hash    $cli_execs                  = {},
  Hash    $credential_defaults        = {},
  Hash    $credentials                = {},
  Hash    $native_credential_defaults = {},
  Hash    $native_credentials         = {},
  Hash    $rogue_defaults             = {},
  Hash    $rogues                     = {},
  Hash    $user_defaults              = {},
  Hash    $users                      = {},
) {

  if $enabled {
    anchor {'ducktape-jenkins-start': } ->
    Class['jenkins::cli_helper'] ->
    File['/usr/local/bin/jenkins-cli'] ->
    Class['ducktape::jenkins::autoload'] ->
    anchor {'ducktape-jenkins-completed': }

    ### Create wrapper for jenkins cli
    $jenkins_cli = "/usr/bin/java -jar ${::jenkins::cli::jar} -s http://127.0.0.1:${jenkins::cli_helper::port}${jenkins::cli_helper::prefix}"
    file {'/usr/local/bin/jenkins-cli':
      ensure => 'present',
      content  => epp('ducktape/jenkins/jenkins-cli', {'command' => $jenkins_cli, 'auth' => regsubst($::jenkins::_cli_auth_arg, "'", "", 'IG')}),
      mode => '0755',
    }

    if $bootstrap {
      Class['ducktape::jenkins::bootstrap'] ~>
      Class['jenkins::cli::reload'] ->
      Class['ducktape::jenkins::autoload']

      include ducktape::jenkins::bootstrap
    }

    include ducktape::jenkins::autoload
  }

}
