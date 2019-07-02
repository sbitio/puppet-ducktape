class ducktape::alternatives (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {

    $alternatives_defaults = hiera('ducktape::alternatives::defaults', {})
    create_resources('alternatives', hiera_hash('ducktape::alternatives', {}), $alternatives_defaults)
  }

}

