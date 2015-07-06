class ducktape::postfix::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $pidfile = $::osfamily ? {
      /(RedHat|Debian)/ => '/var/spool/postfix/pid/master.pid',
    }
    $init_system = $::operatingsystem ? {
      'Ubuntu' => $lsbmajdistrelease ? {
        /(12\.|14\.)/ => 'sysv',
        default       => undef,
      },
      default  => undef,
    }
    $test = {
      type     => connection,
      protocol => smtp,
      port     => 25,
      action   => 'restart',
    }
    monit::check::service { 'postfix':
      init_system => $init_system,
      pidfile     => $pidfile,
      tests       => [$test,]
    }
  }

}

