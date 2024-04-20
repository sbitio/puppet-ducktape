class ducktape::topbeat::external::monit (
  Boolean $enabled = true,
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {
  #TODO# Add more validations
  if $enabled {
    $binary = '/usr/bin/topbeat'
    monit::check::service { 'topbeat':
      matching      => $binary,
      binary        => $binary,
      restart_limit => $restart_limit,
    }
  }
}
