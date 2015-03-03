class ducktape::logstashforwarder::autoload (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $logstashforwarder_file_defaults = hiera('ducktape::logstashforwarder::file::defaults', {})
    create_resources('logstashforwarder::file', hiera_hash('ducktape::logstashforwarder::files', {}), $logstashforwarder_file_defaults)
  }

}

