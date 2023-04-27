class ducktape::openvpn::external::monit(
  Boolean $enabled = true,
  $pidfile,
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {

  if $enabled {
    #TODO# Checks should be created iterating on openvpn::servers:
    #TODO# Add network test
    monit::check::service { 'openvpn':
      pidfile       => $pidfile,
      restart_limit => $restart_limit,
    }
  }

}
