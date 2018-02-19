class ducktape::logstash::external::monit(
  $enabled = true,
  $tests = [],
) {

  validate_bool($enabled)

  if $enabled {

    monit::check::service { 'logstash':
      systemd_file => '/etc/systemd/system/logstash.service',
      pidfile      => '/var/run/logstash.pid',
      binary       => '/usr/bin/java',
      tests        => $tests,
      #TODO# if 5 restarts within 5 cycles then timeout
    }
  }

}

