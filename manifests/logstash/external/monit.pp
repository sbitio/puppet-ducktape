class ducktape::logstash::external::monit(
  $enabled  = true,
  $tests    = [],
) {

  validate_bool($enabled)

  if $enabled {

    monit::check::service { 'logstash':
      binary       => '/usr/bin/java',
      matching     => 'org.logstash.Logstash',
      systemd_file => '/etc/systemd/system/logstash.service',
      tests        => $tests,
      #TODO# if 5 restarts within 5 cycles then timeout
    }
  }

}

