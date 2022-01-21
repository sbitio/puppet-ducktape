class ducktape::openvpn::external::monit(
  Boolean $enabled = true,
  $pidfile,
) {

  if $enabled {
    #TODO# Add network test
    monit::check::service { 'openvpn':
      pidfile => $pidfile,
    }
  }

}

