class ducktape::memcached::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $pidfile = $::osfamily ? {
      'Debian' => $::lsbdistcodename ? {
        jessie  => undef,
        default => '/var/run/memcached.pid',
      },
      'RedHat' => $::lsbmajdistrelease ? {
        7       => undef,
        default => '/var/run/memcached/memcached.pid',
      },
    }
    $matching = $::osfamily ? {
      'Debian' => $::lsbdistcodename ? {
        jessie  =>  '/usr/bin/memcached',
        default => undef,
      },
      'RedHat' => $::lsbmajdistrelease ? {
        7       => '/usr/bin/memcached',
        default => undef,
      },
    }

    $test_tcp = {
      type        => 'connection',
      socket_type => 'tcp',
      port        => $::memcached::tcp_port,
      action      => 'restart',
    }
    $test_udp = {
      type        => 'connection',
      socket_type => 'udp',
      port        => $::memcached::udp_port,
      action      => 'restart',
    }
    monit::check::service { $::memcached::params::service_name:
      pidfile  => $pidfile,
      matching => $matching,
      binary   => '/usr/bin/memcached',
      tests    => [$test_tcp, $test_udp,],
    }
  }

}

