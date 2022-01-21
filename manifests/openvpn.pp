class ducktape::openvpn (
  Boolean $enabled  = true,
  Hash $server_defaults = {},
  Hash $servers = {},
  Hash $client_defaults = {},
  Hash $clients = {},
  Hash $revoke_defaults = {},
  Hash $revokes = {},
) {

  if $enabled {
    include ::ducktape::openvpn::autoload

    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      #TODO# BROKEN, pidfile depends on defines, cannotuse service check include ::ducktape::openvpn::external::monit
    }
  }

}
