class ducktape::postgresql::external::monit(
  Boolean $enabled = true,
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {

  if $enabled {
    #TODO# Add network test
    monit::check::service { 'postgresql':
    }
  }

}
