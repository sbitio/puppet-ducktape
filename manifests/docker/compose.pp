class ducktape::docker::compose (
  Boolean $enabled = true,
) {

  if $enabled {

    $docker_compose_defaults = hiera('ducktape::docker::compose::defaults', {})
    create_resources('docker_compose', hiera_hash('ducktape::docker::compose', {}), $docker_compose_defaults)

  }

}
