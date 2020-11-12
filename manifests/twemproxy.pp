class ducktape::twemproxy (
  $enabled = true,
) {

  if $enabled {
    # External checks.
    if defined('::munin::node') and defined(Class['::munin::node']) {
      include ::ducktape::twemproxy::external::munin_node_plugin
    }
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::twemproxy::external::monit
    }
  }

}
