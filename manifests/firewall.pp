class ducktape::firewall (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ducktape::firewall::autoload
  }

}

