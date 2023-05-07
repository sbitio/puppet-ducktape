class ducktape::postgresql(
  Boolean $enabled = true,
) {

  if $enabled {
    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::postgresql::external::monit
    }
    if defined('::munin::node') and defined(Class['::munin::node']) {
      include ::ducktape::postgresql::external::munin_node_plugin
    }
  }

}
