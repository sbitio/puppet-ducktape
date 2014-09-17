class ducktape::haproxy (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ducktape::haproxy::autoload

    # External checks.
    if defined('::munin::node') and defined(Class['::munin::node']) {
      include ::ducktape::haproxy::external::munin_node_plugin
    }
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::haproxy::external::monit
    }
  }

}

