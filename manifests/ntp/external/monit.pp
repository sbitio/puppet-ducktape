class ducktape::ntp::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $pidfile = $::osfamily ? {
      /(RedHat|Debian)/ => '/var/run/ntpd.pid',
    }

    $test = {
      type        => 'connection',
      socket_type => 'udp',
      port        => 123,
      action      => 'restart',
    }
    monit::check::service { $::ntp::service_name:
      pidfile => $pidfile,
      binary  => $::osfamily ? {
        'Debian' => '/usr/sbin/ntpd',
        default  => undef,
      },
      tests   => [$test, ],
    }
  }

}

