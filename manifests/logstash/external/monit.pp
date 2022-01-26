class ducktape::logstash::external::monit(
  Boolean $enabled,
  Array[Hash] $tests,
) {

  if $enabled {

    monit::check::service { 'logstash':
      binary       => '/usr/bin/java',
      matching     => 'logstash',
      systemd_file => '/etc/systemd/system/logstash.service',
      tests        => $tests,
      #TODO# if 5 restarts within 5 cycles then timeout
    }
  }

}
