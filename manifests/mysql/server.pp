class ducktape::mysql::server inherits ducktape::mysql {

  if $ducktape::mysql::enabled {
    include ducktape::mysql::server::autoload

    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::mysql::external::monit
    }
    if defined('::munin::node') and defined(Class['::munin::node']) {
      include ::ducktape::mysql::external::munin_node_plugin
    }
  }

}
