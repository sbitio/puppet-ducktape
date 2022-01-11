class ducktape::memcached(
  Boolean $enabled = true,
) {

  if $enabled {
    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::memcached::external::monit
    }
    if defined('::munin::node') and defined(Class['::munin::node']) {
      include ::ducktape::memcached::external::munin_node_plugin
    }
  }

}
