class ducktape::elasticsearch::external::monit(
  Boolean $enabled      = true,
  Stdlib::Absolutepath $systemd_file = '/lib/systemd/system/elasticsearch-es01.service',
  Array[String] $tests = [],
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {

  if $enabled {

    monit::check::service { 'elasticsearch':
      binary        => '/usr/bin/java',
      matching      => 'elasticsearch',
      systemd_file  => $systemd_file,
      tests         => $tests,
      restart_limit => $restart_limit,
    }
  }

}
