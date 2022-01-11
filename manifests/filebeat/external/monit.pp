class ducktape::filebeat::external::monit(
  Boolean $enabled = true,
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
