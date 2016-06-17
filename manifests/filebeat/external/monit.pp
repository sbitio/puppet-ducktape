class ducktape::filebeat::external::monit(
  $enabled        = true,
) {

  validate_bool($enabled)
  #TODO# Add more validations

  if $enabled {
    $pidfile = '/var/run/filebeat.pid'
    monit::check::service { 'filebeat':
      pidfile => $pidfile,
    }
  }

}

