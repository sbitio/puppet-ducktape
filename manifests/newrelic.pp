class ducktape::newrelic (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::newrelic::external::monit
    }

    create_resources('newrelic::server', hiera_hash('ducktape::newrelic::server', {}))
    if defined('::php') and defined(Class['::php']) {
      create_resources('newrelic::php', hiera_hash('ducktape::newrelic::php',{}))
    }
  }

}

