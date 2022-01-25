class ducktape::openvpn::external::monit(
  Boolean $enabled,
  $pidfile,
) {

  if $enabled {
    #TODO# Add network test
    monit::check::service { 'openvpn':
      pidfile => $pidfile,
    }
  }

}
