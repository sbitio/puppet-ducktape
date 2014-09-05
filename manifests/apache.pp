class ducktape::apache (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $defaults = hiera('ducktape::apache::conf::defaults', {})
    $confs    = hiera_hash('ducktape::apache::confs', {})
    create_resources('::ducktape::apache::conf', $confs, $defaults)
  }

}

