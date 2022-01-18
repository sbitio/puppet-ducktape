class ducktape::haproxy::external::monit(
  Boolean $enabled = true,
  String  $action  = 'restart',
  Hash $conn_tolerance = { cycles => 1 },
) {

  if $enabled {
    contain ducktape::haproxy::autoload
    #TODO# create a connection test for each frontend

    $init_system = $::operatingsystem ? {
      'Ubuntu' => $::lsbmajdistrelease ? {
        /(12\.|14\.)/ => 'sysv',
        default       => undef,
      },
      default  => undef,
    }
    $port_hive = $ducktape::haproxy::frontends
    $connection_test = {
      type     => 'connection',
      protocol => 'http',
      protocol_test => {
        # TODO find a way to get this from hiera
        request => '/haproxy',
      },
      port     => $port_hive['stats_fe']['ports'],
      action   => $action,
      tolerance => $conn_tolerance,
    }
    monit::check::service { 'haproxy':
      init_system => $init_system,
      pidfile     => $::haproxy::params::global_options['pidfile'],
      tests       => [$connection_test, ],
      #TODO# if 5 restarts within 5 cycles then timeout
    }
  }

}

