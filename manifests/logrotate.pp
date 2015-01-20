class ducktape::logrotate (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ducktape::logrotate::autoload
  }

}

