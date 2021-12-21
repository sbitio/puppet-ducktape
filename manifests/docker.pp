class ducktape::docker (
  Boolean $enabled = true,
) {

  require ::ducktape::docker::compose

  if $enabled {
    # External checks.
    if defined('::munin::node') and defined(Class['::munin::node']) {
      include ::ducktape::docker::external::munin_node_plugin
    }
  }

}
