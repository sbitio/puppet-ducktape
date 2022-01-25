class ducktape::ntp::external::monit(
  Boolean $enabled,
  String $action,
) {

  if $enabled {
    $pidfile = $::osfamily ? {
      'Debian' => '/var/run/ntpd.pid',
      'RedHat' => $::lsbmajdistrelease ? {
        7       => undef,
        default => '/var/run/ntpd.pid',
      },
    }
    $matching = $::osfamily ? {
      'Debian' => undef,
      'RedHat' => $::lsbmajdistrelease ? {
        7       => '/usr/sbin/ntpd',
        default => undef,
      },
    }
    $init_system = $::operatingsystem ? {
      'Ubuntu' => $::lsbmajdistrelease ? {
        /(12\.|14\.)/ => 'sysv',
        default       => undef,
      },
      'Debian' => $::lsbdistcodename ? {
        'jessie'  => 'sysv',
        'stretch' => 'sysv',
        default   => undef,
      },
      default  => undef,
    }

    $test = {
      type        => 'connection',
      socket_type => 'udp',
      port        => 123,
      action      => $action,
    }
    monit::check::service { $::ntp::service_name:
      init_system => $init_system,
      pidfile     => $pidfile,
      matching    => $matching,
      binary      => $::osfamily ? {
        'Debian' => '/usr/sbin/ntpd',
        default  => undef,
      },
      tests       => [$test, ],
    }
  }

}
