class ducktape::openvpn::external::monit(
  $enabled = true,
  $pidfile,
) {

  validate_bool($enabled)

  if $enabled {
    #TODO# Add network test
    monit::check::service { 'openvpn':
      pidfile => $pidfile,
    }
  }

}

