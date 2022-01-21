class ducktape::newrelic::external::monit(
  Boolean $enabled = true,
) {

  if $enabled {
    if $::newrelic::enable_php_agent {
      monit::check::service { 'newrelic-daemon':
        group         => 'newrelic',
        init_system   => 'sysv',
        binary        => '/usr/bin/newrelic-daemon',
        pidfile       => '/var/run/newrelic-daemon.pid',
        program_start => '/etc/init.d/newrelic-daemon start',
        program_stop  => '/etc/init.d/newrelic-daemon stop',
      }
    }
    if $::newrelic::enable_infra {
      monit::check::service { 'newrelic-infra':
        group   => 'newrelic',
        binary  => '/usr/bin/newrelic-infra',
        systemd_file => '/etc/systemd/system/newrelic-infra.service',
        pidfile => '/var/run/newrelic-infra/newrelic-infra.pid',
      }
    }
  }

}
