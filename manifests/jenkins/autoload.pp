class ducktape::jenkins::autoload (
  Boolean $cli_exec                   = true,
  Boolean $credential                 = true,
  Boolean $native_credential          = true,
  Boolean $rogue                      = true,
  Boolean $user                       = true,
) {

  if $cli_exec {
    create_resources('jenkins::cli::exec', $ducktape::jenkins::cli_execs, $ducktape::jenkins::cli_exec_defaults)
  }

  if $credential {
    # Prepend key with an empty line, a dirty workaround based on https://issues.jenkins-ci.org/browse/JENKINS-30652?focusedCommentId=333715&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-333715
    $ducktape::jenkins::credentials.each |String $name, Hash $params| {
      if $params[private_key_or_path] and $params[private_key_or_path] =~ /^-/ {
        $modified_params = {
          private_key_or_path => "\n${params[private_key_or_path]}"
        }
        create_resources('jenkins::credentials', { $name => $params + $modified_params }, $ducktape::jenkins::credential_defaults)
      }
      else {
        create_resources('jenkins::credentials', { $name => $params }, $ducktape::jenkins::credential_defaults)
      }
    }
  }

  if $native_credential {
    create_resources('jenkins_credentials', $ducktape::jenkins::native_credentials, $ducktape::jenkins::native_credential_defaults)
  }

  if $rogue {
    $rogue_main_defaults = {
      environment => [
        'JENKINS_CLI=/usr/local/bin/jenkins-cli groovy =',
      ],
      logoutput => true,
    }
    create_resources('exec', $ducktape::jenkins::rogues, $rogue_main_defaults + $ducktape::jenkins::rogue_defaults)
  }

  if $user {
    create_resources('jenkins::user', $ducktape::jenkins::users, $ducktape::jenkins::user_defaults)
  }

}
