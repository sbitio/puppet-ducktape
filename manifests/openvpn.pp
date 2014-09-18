class ducktape::openvpn (
  $enabled  = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ::ducktape::openvpn::autoload

    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      # BROKEN, pidfile depends on defines, cannotuse service check include ::ducktape::openvpn::external::monit
    }
  }

}

