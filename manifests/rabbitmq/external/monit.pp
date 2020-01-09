class ducktape::rabbitmq::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    monit::check::service { 'rabbitmq-server':
      matching => 'rabbitmq-server',
      binary => '/usr/sbin/rabbitmq-server',
    }
  }

}
