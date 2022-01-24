class ducktape::docker::compose (
  Boolean $enabled = true,
) {

  if $enabled {

    create_resources('docker_compose', $ducktape::docker::compose, $ducktape::docker::compose_defaults)

  }

}
