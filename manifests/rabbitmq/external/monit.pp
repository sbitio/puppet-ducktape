class ducktape::rabbitmq::external::monit(
  Boolean $enabled = true,
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {

  if $enabled {
    monit::check::service { 'rabbitmq-server':
      matching      => 'rabbitmq-server',
      binary        => '/usr/sbin/rabbitmq-server',
      restart_limit => $restart_limit,
    }
  }

}
