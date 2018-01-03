class ducktape::systemd (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ducktape::systemd::autoload
  }

}

