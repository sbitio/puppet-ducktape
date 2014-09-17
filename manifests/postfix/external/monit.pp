class ducktape::postfix::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $pidfile = $::osfamily ? {
      /(RedHat|Debian)/ => '/var/spool/postfix/pid/master.pid',
    }
    $test = {
      type     => connection,
      protocol => smtp,
      port     => 25,
    }
    monit::check::service { 'postfix':
      pidfile => $pidfile,
      tests   => [$test,]
    }
  }

}

