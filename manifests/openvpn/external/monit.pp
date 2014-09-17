class ducktape::openvpn::external::monit(
  $enabled = true,
  $pidfile,
) {

  validate_bool($enabled)

  if $enabled {
    monit::check::service { 'openvpn':
      pidfile => $pidfile,
    }
  }

}

