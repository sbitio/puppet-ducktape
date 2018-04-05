class ducktape::redis (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    # Declare instances.
    $instance_defaults = hiera('ducktape::redis::instance::defaults', {})
    $instances = hiera_hash('ducktape::redis::instances', {})
    create_resources('::redis::instance', $instances, $instance_defaults)

    # External checks.
    if defined('::munin::node') and defined(Class['::munin::node']) {
      include ::ducktape::redis::external::munin_node_plugin
    }
  }

}

