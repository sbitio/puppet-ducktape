class ducktape::topbeat::external::monit(
  Boolean $enabled = true,
) {
  #TODO# Add more validations

  if $enabled {
    $binary = '/usr/bin/topbeat'
    monit::check::service { 'topbeat':
      matching => $binary,
      binary   => $binary,
    }
  }

}
