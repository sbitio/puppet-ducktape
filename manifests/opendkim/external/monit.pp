class ducktape::opendkim::external::monit(
  $enabled = true,
  $action  = 'restart',
  $port    = $::ducktape::opendkim::port,
) {

  validate_bool($enabled)

  if $enabled {
    $init_system = $::operatingsystem ? {
      'Debian' => $::lsbdistcodename ? {
        'jessie' => 'sysv',
        default  => undef,
      },
      default  => undef,
    }

    $pidfile = $::osfamily ? {
      /(RedHat|Debian)/ => '/var/run/opendkim/opendkim.pid',
    }
    $test = {
      type     => connection,
      port     => $port,
      action   => $action,
    }
    monit::check::service { 'opendkim':
      init_system => $init_system,
      pidfile     => $pidfile,
      tests       => [$test,]
    }
  }

}

