class ducktape::ntp::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $pidfile = $::osfamily ? {
      /(RedHat|Debian)/ => '/var/run/ntpd.pid',
    }

    $test = {
      type        => connection,
      socket_type => udp,
      port        => 123,
    }
    monit::check::service { $::ntp::service_name:
      pidfile => $pidfile,
      tests   => [$test, ],
    }
  }

}

