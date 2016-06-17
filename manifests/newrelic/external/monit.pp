class ducktape::newrelic::external::monit(
  $enabled        = true,
) {

  validate_bool($enabled)
  #TODO# Add more validations

  if $enabled {
    $pidfile_daemon = '/var/run/newrelic-daemon.pid'
    $pidfile_nrsysmond = '/var/run/newrelic/nrsysmond.pid'
    $init_system = 'sysv'
    monit::check::service { 'newrelic-daemon':
      init_system => $init_system,
      pidfile => $pidfile_daemon,
    }
    monit::check::service { 'newrelic-sysmond':
      init_system => $init_system,
      pidfile => $pidfile_nrsysmond,
    }
  }

}

