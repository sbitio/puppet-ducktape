class ducktape::rsyslog::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $binary = $::osfamily ? {
      'RedHat' => $::lsbmajdistrelease ? {
        6       => '/sbin/rsyslogd',
        default => '/usr/sbin/rsyslogd',
      },
      default => '/usr/sbin/rsyslogd',
    }
    $matching = $::osfamily ? {
      'Debian' => (versioncmp($::operatingsystemrelease, '9') >= 0) ? {
        true  => '/usr/sbin/rsyslogd',
        false => undef,
      },
      default => undef,
    }
    $pidfile = $::osfamily ? {
      'Debian' => (versioncmp($::operatingsystemrelease, '9') >= 0) ? {
        true  => undef,
        false => '/var/run/rsyslogd.pid',
      },
      'RedHat' => '/var/run/syslogd.pid',
    }

    monit::check::service { 'rsyslog':
      binary   => $binary,
      matching => $matching,
      pidfile  => $pidfile,
    }
  }

}

