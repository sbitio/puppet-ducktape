class ducktape::rsyslog::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $pidfile = $::osfamily ? {
      'Debian' => '/var/run/rsyslogd.pid',
      'RedHat' => '/var/run/syslogd.pid',
    }

    $binary = $::osfamily ? {
      'RedHat' => $::lsbmajdistrelease ? {
        6       => '/sbin/rsyslogd',
        default => '/usr/sbin/rsyslogd',
      },
      default => '/usr/sbin/rsyslogd',
    }

    monit::check::service { 'rsyslog':
      pidfile  => $pidfile,
      binary   => $binary,
    }
  }

}

