class ducktape::openvpn (
  $enabled  = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ::ducktape::openvpn::autoload
  }

}

