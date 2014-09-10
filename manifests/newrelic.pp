class ducktape::newrelic (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    create_resources('newrelic::server', hiera_hash('newrelic::server',{}))
    create_resources('newrelic::php', hiera_hash('newrelic::php',{}))
  }

}

