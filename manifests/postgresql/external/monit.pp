class ducktape::postgresql::external::monit(
  $enabled    = true,
) {

  validate_bool($enabled)

  if $enabled {
    #TODO# Add network test
    monit::check::service { 'postgresql':
    }
  }

}

