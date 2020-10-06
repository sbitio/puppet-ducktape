class ducktape::redis (
  Boolean $enabled = true,
) {

  if $enabled {
    # External checks.
    if defined('::munin::node') and defined(Class['::munin::node']) {
      include ::ducktape::redis::external::munin_node_plugin
    }
  }

}

