class ducktape::newrelic::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    monit::check::service { 'newrelic-daemon':
      group         => 'newrelic',
      init_system   => 'sysv',
      binary        => '/usr/bin/newrelic-daemon',
      pidfile       => '/var/run/newrelic-daemon.pid',
      program_start => '/etc/init.d/newrelic-daemon start',
      program_stop  => '/etc/init.d/newrelic-daemon stop',
    }
    monit::check::service { 'newrelic-sysmond':
      group         => 'newrelic',
      init_system   => 'sysv',
      binary        => '/usr/sbin/nrsysmond',
      pidfile       => '/var/run/newrelic/nrsysmond.pid',
      program_start => '/etc/init.d/newrelic-sysmond start',
      program_stop  => '/etc/init.d/newrelic-sysmond stop',
    }
  }

}

