class ducktape::elasticsearch::external::monit(
  Boolean $enabled,
  Stdlib::Absolutepath $systemd_file,
  Array[String] $tests,
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
