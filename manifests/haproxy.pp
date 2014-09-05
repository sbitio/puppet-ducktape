class ducktape::haproxy (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ducktape::haproxy::autoload
  }

}

