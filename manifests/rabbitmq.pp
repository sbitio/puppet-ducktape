class ducktape::rabbitmq (
  Boolean $enabled = true,
  Hash $vhost_defaults = {},
  Hash $vhosts = {},
  Hash $exchange_defaults = {},
  Hash $exchanges = {},
  Hash $queue_defaults = {},
  Hash $queues = {},
  Hash $user_defaults = {},
  Hash $users = {},
  Hash $user_permissions_defaults = {},
  Hash $user_permissions = {},
) {

  if $enabled {
    include ducktape::rabbitmq::autoload

    # External configs.
    if defined('::munin::node') and defined(Class['::munin::node']) {
      include ::ducktape::rabbitmq::external::munin_node_plugin
    }
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::rabbitmq::external::monit
    }
  }

}
