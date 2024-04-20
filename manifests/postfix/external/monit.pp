class ducktape::postfix::external::monit (
  Boolean $enabled = true,
  String $action  = 'restart',
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {
  if $enabled {
    $pidfile = $facts['os']['family'] ? {
      /(RedHat|Debian)/ => '/var/spool/postfix/pid/master.pid',
    }
    $init_system = $facts['os']['name'] ? {
      'Ubuntu' => $facts['os']['distro']['release']['major'] ? {
        /(12\.|14\.)/ => 'sysv',
        default       => undef,
      },
      'Debian' => $facts['os']['distro']['codename'] ? {
        'jessie' => 'sysv',
        default  => undef,
      },
      default  => undef,
    }
    $test = {
      type     => connection,
      protocol => smtp,
      port     => 25,
      action   => $action,
    }
    monit::check::service { 'postfix':
      init_system   => $init_system,
      pidfile       => $pidfile,
      tests         => [$test,],
      restart_limit => $restart_limit,
    }
  }
}
