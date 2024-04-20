class ducktape::opendkim::external::monit (
  Boolean $enabled = true,
  String $action  = 'restart',
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {
  if $enabled {
    $init_system = $facts['os']['name'] ? {
      'Debian' => $facts['os']['distro']['codename'] ? {
        'jessie' => 'sysv',
        default  => undef,
      },
      default  => undef,
    }

    $pidfile = $facts['os']['family'] ? {
      /(RedHat|Debian)/ => '/var/run/opendkim/opendkim.pid',
    }
    $test = {
      type     => connection,
      port     => $ducktape::opendkim::port,
      action   => $action,
    }
    monit::check::service { 'opendkim':
      init_system   => $init_system,
      pidfile       => $pidfile,
      tests         => [$test,],
      restart_limit => $restart_limit,
    }
  }
}
