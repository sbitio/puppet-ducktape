class ducktape::rabbitmq::autoload (
  Boolean $load_vhosts,
  Boolean $load_exchanges,
  Boolean $load_queues,
  Boolean $load_users,
  Boolean $load_user_permissions,
) {

  if $load_vhosts {
    create_resources('rabbitmq_vhost', $ducktape::rabbitmq::vhosts, $ducktape::rabbitmq::vhost_defaults)
  }

  if $load_exchanges {
    create_resources('rabbitmq_exchange', $ducktape::rabbitmq::exchanges, $ducktape::rabbitmq::exchange_defaults)
  }

  if $load_queues {
    create_resources('rabbitmq_queue', $ducktape::rabbitmq::queues, $ducktape::rabbitmq::queue_defaults)
  }

  if $load_users {
    create_resources('rabbitmq_user', $ducktape::rabbitmq::users, $ducktape::rabbitmq::user_defaults)
  }

  if $load_user_permissions {
    create_resources('rabbitmq_user_permissions', $ducktape::rabbitmq::user_permissions, $ducktape::rabbitmq::user_permissions_defaults)
  }

}
