class ducktape::rsyslog::external::monit (
  Boolean $enabled = true,
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {
  if $enabled {
    $binary = $facts['os']['family'] ? {
      'RedHat' => $facts['os']['distro']['release']['major'] ? {
        6       => '/sbin/rsyslogd',
        default => '/usr/sbin/rsyslogd',
      },
      default => '/usr/sbin/rsyslogd',
    }
    $matching = $facts['os']['family'] ? {
      'Debian' => (versioncmp($facts['os']['release']['full'], '9') >= 0) ? {
        true  => '/usr/sbin/rsyslogd',
        false => undef,
      },
      default => undef,
    }
    $pidfile = $facts['os']['family'] ? {
      'Debian' => (versioncmp($facts['os']['release']['full'], '9') >= 0) ? {
        true  => undef,
        false => '/var/run/rsyslogd.pid',
      },
      'RedHat' => '/var/run/syslogd.pid',
    }

    monit::check::service { 'rsyslog':
      binary        => $binary,
      matching      => $matching,
      pidfile       => $pidfile,
      restart_limit => $restart_limit,
    }
  }
}
