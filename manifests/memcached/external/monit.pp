class ducktape::memcached::external::monit(
  Boolean $enabled = true,
  String $action  = 'restart',
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {

  if $enabled {
    $pidfile = $::osfamily ? {
      'Debian' => $::lsbdistcodename ? {
        'wheezy' => '/var/run/memcached.pid',
        default  => undef,
      },
      'RedHat' => $::lsbmajdistrelease ? {
        7       => undef,
        default => '/var/run/memcached/memcached.pid',
      },
    }
    $matching = $::osfamily ? {
      'Debian' => $::lsbdistcodename ? {
        'wheezy' => undef,
        default  =>  '/usr/bin/memcached',
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
      action      => $action,
    }
    $test_udp = {
      type        => 'connection',
      socket_type => 'udp',
      port        => $::memcached::udp_port,
      action      => $action,
    }
    monit::check::service { $::memcached::params::service_name:
      pidfile       => $pidfile,
      matching      => $matching,
      binary        => '/usr/bin/memcached',
      tests         => [$test_tcp, $test_udp,],
      restart_limit => $restart_limit,
    }
  }

}
