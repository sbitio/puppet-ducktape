class ducktape::openvpn (
  Boolean $enabled  = true,
) {

  if $enabled {
    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::openvpn::external::monit
    }
  }

}
