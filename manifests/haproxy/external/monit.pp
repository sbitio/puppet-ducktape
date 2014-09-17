class ducktape::haproxy::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    #TODO# create a connection test for each frontend

    $connection_test = {
      type     => connection,
      protocol => http,
      port     => hiera('ducktape::haproxy::frontends::stats1::port'),
    }
    monit::check::service { 'haproxy':
      pidfile       => $::haproxy::params::global_options['pidfile'],
      tests         => [$connection_test, ],
      #TODO# if 5 restarts within 5 cycles then timeout
    }
  }

}

