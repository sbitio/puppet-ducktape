class ducktape::filebeat::external::monit(
  Boolean $enabled,
) {
  #TODO# Add more validations

  if $enabled {
    $binary = '/usr/share/filebeat/bin/filebeat'
    monit::check::service { 'filebeat':
      matching => $binary,
      binary   => $binary,
    }
  }

}
