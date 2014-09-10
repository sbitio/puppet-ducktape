class ducktape::newrelic (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    create_resources('newrelic::server', hiera_hash('newrelic::server',{}))
    if defined('::php') and defined(Class['::php']) {
      create_resources('newrelic::php', hiera_hash('newrelic::php',{}))
    }
  }

}

