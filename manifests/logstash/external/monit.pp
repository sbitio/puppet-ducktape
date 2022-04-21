class ducktape::logstash::external::monit(
  Boolean $enabled  = true,
  Array[Hash] $tests = [],
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {

  if $enabled {

    monit::check::service { 'logstash':
      binary        => '/usr/bin/java',
      matching      => 'logstash',
      systemd_file  => '/etc/systemd/system/logstash.service',
      tests         => $tests,
      restart_limit => $restart_limit,
    }
  }

}
