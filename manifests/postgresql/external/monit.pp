class ducktape::postgresql::external::monit(
  $enabled    = true,
) {

  validate_bool($enabled)

  if $enabled {
    monit::check::service { 'postgresql':
    }
  }

}

