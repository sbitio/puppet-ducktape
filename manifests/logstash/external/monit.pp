class ducktape::logstash::external::monit(
  $enabled          = true,
) {

  validate_bool($enabled)

  if $enabled {

    monit::check::service { 'logstash':
      pidfile => '/var/run/logstash.pid',
      binary  => '/usr/bin/java',
      tests   => $ducktape::logstash::external::monit::tests,
      #TODO# if 5 restarts within 5 cycles then timeout
    }
  }

}

