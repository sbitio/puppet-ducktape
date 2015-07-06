class ducktape::ntp::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $pidfile = $::osfamily ? {
      'Debian' => '/var/run/ntpd.pid',
      'RedHat' => $::lsbmajdistrelease ? {
        7       => undef,
        default => '/var/run/ntpd.pid',
      },
    }
    $init_system = $::operatingsystem ? {
      'Ubuntu' => $lsbmajdistrelease ? {
        /(12\.|14\.)/ => 'sysv',
        default       => undef,
      },
      default  => undef,
    }

    $matching = $::osfamily ? {
      'Debian' => undef,
      'RedHat' => $::lsbmajdistrelease ? {
        7       => '/usr/sbin/ntpd',
        default => undef,
      },
    }

    $test = {
      type        => 'connection',
      socket_type => 'udp',
      port        => 123,
      action      => 'restart',
    }
    monit::check::service { $::ntp::service_name:
      init_system => $init_system,
      pidfile     => $pidfile,
      matching    => $matching,
      binary   => $::osfamily ? {
        'Debian' => '/usr/sbin/ntpd',
        default  => undef,
      },
      tests   => [$test, ],
    }
  }

}

