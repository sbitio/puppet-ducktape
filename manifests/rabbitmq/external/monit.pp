class ducktape::rabbitmq::external::monit(
  Boolean $enabled,
) {

  if $enabled {
    monit::check::service { 'rabbitmq-server':
      matching => 'rabbitmq-server',
      binary => '/usr/sbin/rabbitmq-server',
    }
  }

}
