class ducktape::filebeat::external::monit(
  $enabled        = true,
) {

  validate_bool($enabled)
  #TODO# Add more validations

  if $enabled {
    $binary = '/usr/bin/filebeat-god'
    monit::check::service { 'filebeat':
      matching => $binary,
      binary   => $binary,
    }
  }

}

