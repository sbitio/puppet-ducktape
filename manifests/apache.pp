class ducktape::apache (
  Boolean $enabled = true,
  Hash $conf_defaults = {},
  Hash $confs = {},
) {
  if $enabled {
    require ducktape::apache::autoload

    # External checks.
    if defined('monit') and defined(Class['monit']) {
      include ducktape::apache::external::monit
    }
    if defined('munin::node') and defined(Class['munin::node']) {
      include ducktape::apache::external::munin_node_plugin
    }
    # Autoincluded classes
    include ducktape::apache::shield_vhost
  }
}
