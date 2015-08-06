class ducktape::rabbitmq::autoload (
  $load_vhosts    = true,
  $load_exchanges = true,
  $load_queues    = true,
) {

  validate_bool($load_vhosts)
  validate_bool($load_exchanges)

  if $load_vhosts {
    $rabbitmq_vhost_defaults = hiera('ducktape::rabbitmq::vhost::defaults', {})
    create_resources('rabbitmq_vhost', hiera_hash('ducktape::rabbitmq::vhosts', {}), $rabbitmq_vhost_defaults)
  }

  if $load_exchanges {
    $rabbitmq_exchange_defaults = hiera('ducktape::rabbitmq::exchange::defaults', {})
    create_resources('rabbitmq_exchange', hiera_hash('ducktape::rabbitmq::exchanges', {}), $rabbitmq_exchange_defaults)
  }

  if $load_queues {
    $rabbitmq_queue_defaults = hiera('ducktape::rabbitmq::queue::defaults', {})
    create_resources('rabbitmq_queue', hiera_hash('ducktape::rabbitmq::queues', {}), $rabbitmq_queue_defaults)
  }

}

