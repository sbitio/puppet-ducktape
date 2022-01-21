class ducktape::elasticsearch::external::monit(
  Boolean $enabled      = true,
  Stdlib::Absolutepath $systemd_file = '/lib/systemd/system/elasticsearch-es01.service',
  Array[String] $tests = [],
) {

  if $enabled {

    monit::check::service { 'elasticsearch':
      binary       => '/usr/bin/java',
      matching     => 'elasticsearch',
      systemd_file => $systemd_file,
      tests        => $tests,
      #TODO# if 5 restarts within 5 cycles then timeout
    }
  }

}
