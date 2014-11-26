class ducktape::memcached::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $pidfile = $::osfamily ? {
      'RedHat' => '/var/run/memcached/memcached.pid',
      'Debian' => '/var/run/memcached.pid',
    }

    $test_tcp = {
      type        => connection,
      socket_type => tcp,
      port        => $::memcached::tcp_port,
    }
    $test_udp = {
      type        => connection,
      socket_type => udp,
      port        => $::memcached::udp_port,
    }
    monit::check::service { $::memcached::params::service_name:
      pidfile => $pidfile,
      binary  => $::osfamily ? {
        'Debian' => '/usr/bin/memcached',
        default  => undef,
      },
      tests   => [$test_tcp, $test_udp,],
    }
  }

}

