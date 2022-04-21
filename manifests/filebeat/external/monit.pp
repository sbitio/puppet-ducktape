class ducktape::filebeat::external::monit(
  Boolean $enabled = true,
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {
  #TODO# Add more validations

  if $enabled {
    $binary = '/usr/share/filebeat/bin/filebeat'
    monit::check::service { 'filebeat':
      matching      => $binary,
      binary        => $binary,
      restart_limit => $restart_limit,
    }
  }

}
