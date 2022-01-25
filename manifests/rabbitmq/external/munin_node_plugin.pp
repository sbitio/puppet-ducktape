class ducktape::rabbitmq::external::munin_node_plugin(
  Boolean $enabled,
) {
  if $enabled and $ducktape::munin::node::enabled and $ducktape::munin::node::manage_repo {

    @munin::node::plugin { 'rabbitmq_connections':
      target => "${::ducktape::munin::node::contrib_plugins_path}/plugins/rabbitmq/rabbitmq_connections",
      config => [
        'user rabbitmq',
        'group rabbitmq',
      ],
      require => [
        Class['::rabbitmq'],
      ],
    }

    # Per vhost plugins.
    $plugins = [
	    'rabbitmq_consumers',
	    'rabbitmq_messages',
	    'rabbitmq_messages_unacknowledged',
	    'rabbitmq_messages_uncommitted',
	    'rabbitmq_queue_memory',
    ]

    $ducktape::rabbitmq::vhosts.each |$vhost, $definition| {
      $plugins.each |$index, $plugin| {
        @munin::node::plugin { "${plugin}_${vhost}":
          target => "${::ducktape::munin::node::contrib_plugins_path}/plugins/rabbitmq/${plugin}",
          config => [
            'user rabbitmq',
            'group rabbitmq',
            "env.vhost $vhost",
          ],
          require => [
            Class['::rabbitmq'],
          ],
        }
      }
    }
  }
}
