class ducktape::logstash::external::monit (
  Boolean $enabled  = true,
  String[1] $binary = '/usr/share/logstash/jdk/bin/java',
  String[1] $matching = $binary,
  Array[Hash] $tests = [],
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {
  if $enabled {
    monit::check::service { 'logstash':
      binary        => $binary,
      matching      => $matching,
      systemd_file  => '/etc/systemd/system/logstash.service',
      tests         => $tests,
      restart_limit => $restart_limit,
    }
  }
}
