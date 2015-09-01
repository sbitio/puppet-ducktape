class ducktape::opendkim::external::monit(
  $enabled = true,
  $port    = $::ducktape::opendkim::port,
) {

  validate_bool($enabled)

  if $enabled {
    $pidfile = $::osfamily ? {
      /(RedHat|Debian)/ => '/var/run/opendkim/opendkim.pid',
    }
    $test = {
      type     => connection,
      protocol => smtp,
      port     => $port,
      action   => 'restart',
    }
    monit::check::service { 'opendkim':
      pidfile     => $pidfile,
      tests       => [$test,]
    }
  }

}

