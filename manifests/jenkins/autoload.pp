class ducktape::jenkins::autoload (
  Boolean $cli_exec                   = true,
  Hash    $cli_exec_defaults          = {},
  Hash    $cli_execs                  = {},
  Boolean $credential                 = true,
  Hash    $credential_defaults        = {},
  Hash    $credentials                = {},
  Boolean $native_credential          = true,
  Hash    $native_credential_defaults = {},
  Hash    $native_credentials         = {},
  Boolean $rogue                      = true,
  Hash    $rogue_defaults             = {},
  Hash    $rogues                     = {},
  Boolean $user                       = true,
  Hash    $user_defaults              = {},
  Hash    $users                      = {},
) {

  if $cli_exec {
    create_resources('jenkins::cli::exec', $cli_execs, $cli_exec_defaults)
  }

  if $credential {
    # Prepend key with an empty line, a dirty workaround based on https://issues.jenkins-ci.org/browse/JENKINS-30652?focusedCommentId=333715&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-333715
    $credentials.each |String $name, Hash $params| {
      if $params[private_key_or_path] and $params[private_key_or_path] =~ /^-/ {
        $modified_params = {
          private_key_or_path => "\n${params[private_key_or_path]}"
        }
        create_resources('jenkins::credentials', { $name => $params + $modified_params }, $credential_defaults)
      }
      else {
        create_resources('jenkins::credentials', { $name => $params }, $credential_defaults)
      }
    }
  }

  if $native_credential {
    create_resources('jenkins_credentials', $native_credentials, $native_credential_defaults)
  }

  if $rogue {
    $rogue_main_defaults = {
      environment => [
        "JENKINS_CLI=/usr/bin/java -jar ${::jenkins::libdir}/jenkins-cli.jar -s http://127.0.0.1:8080 -auth ${::jenkins::cli_username}:${::jenkins::cli_password} groovy =",
      ],
      subscribe => Exec['ducktape-jenkins-bootstrap-cmd'],
      require =>  Class['jenkins::cli_helper'],
      logoutput => true,
    }
    create_resources('exec', $rogues, $rogue_main_defaults + $rogue_defaults)
  }

  if $user {
    create_resources('jenkins::user', $users, $user_defaults)
  }

}
