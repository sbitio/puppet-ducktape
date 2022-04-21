class ducktape::postfix::external::monit(
  Boolean $enabled = true,
  String $action  = 'restart',
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {

  if $enabled {
    $pidfile = $::osfamily ? {
      /(RedHat|Debian)/ => '/var/spool/postfix/pid/master.pid',
    }
    $init_system = $::operatingsystem ? {
      'Ubuntu' => $::lsbmajdistrelease ? {
        /(12\.|14\.)/ => 'sysv',
        default       => undef,
      },
      'Debian' => $::lsbdistcodename ? {
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
