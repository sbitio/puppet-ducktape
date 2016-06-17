class ducktape::newrelic::external::monit(
  $enabled        = true,
) {

  validate_bool($enabled)
  #TODO# Add more validations

  if $enabled {
    $pidfile_daemon = '/var/run/newrelic-daemon.pid'
    $pidfile_nrsysmond = '/var/run/newrelic/nrsysmond.pid'
    monit::check::service { 'newrelic-daemon':
      pidfile => $pidfile_daemon,
    }
    monit::check::service { 'nrsysmond':
      pidfile => $pidfile_nrsysmond,
    }
  }

}

