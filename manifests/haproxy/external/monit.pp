class ducktape::haproxy::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    #TODO# create a connection test for each frontend

    $port_hive = hiera('ducktape::haproxy::frontends')
    $connection_test = {
      type     => connection,
      protocol => http,
      port     => $port_hive['stats1']['ports'],
    }
    monit::check::service { 'haproxy':
      pidfile       => $::haproxy::params::global_options['pidfile'],
      tests         => [$connection_test, ],
      #TODO# if 5 restarts within 5 cycles then timeout
    }
  }

}

