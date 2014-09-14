class ducktape::haproxy (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ducktape::haproxy::autoload

    if defined('::munin::node') and defined(Class['::munin::node']) {
      include ::ducktape::haproxy::external::munin_node_plugin
    }
  }

}

