class ducktape::rsyslog::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $pidfile = $::osfamily ? {
      'Debian' => '/var/run/rsyslogd.pid',
      'RedHat' => '/var/run/syslogd.pid',
    }

    monit::check::service { 'rsyslog':
      pidfile  => $pidfile,
    }
  }

}

