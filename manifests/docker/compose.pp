class ducktape::docker::compose (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {

    $docker_compose_defaults = hiera('ducktape::docker::compose::defaults', {})
    create_resources('docker_compose', hiera_hash('ducktape::docker::compose', {}), $docker_compose_defaults)

  }

}

