class ducktape::logstash::autoload (
  $load_configfiles  = true,
  $load_patternfiles = true,
  $load_plugins      = true,
  $load_lumberjacks  = true,
) {

  validate_bool($load_configfiles)
  validate_bool($load_patternfiles)
  validate_bool($load_plugins)
  validate_bool($load_lumberjacks)

  if $load_configfiles {
    $logstash_configfile_defaults = hiera('ducktape::logstash::configfile::defaults', {})
    create_resources('logstash::configfile', hiera_hash('ducktape::logstash::configfiles', {}), $logstash_configfile_defaults)
  }

  if $load_patternfiles {
    $logstash_patternfile_defaults = hiera('ducktape::logstash::patternfile::defaults', {})
    create_resources('logstash::patternfile', hiera_hash('ducktape::logstash::patternfiles', {}), $logstash_patternfile_defaults)
  }

  if $load_plugins {
    $logstash_plugin_defaults = hiera('ducktape::logstash::plugin::defaults', {})
    create_resources('logstash::plugin', hiera_hash('ducktape::logstash::plugins', {}), $logstash_plugin_defaults)
  }

  if $load_lumberjacks {
    $logstash_lumberjack_defaults = hiera('ducktape::logstash::lumberjack::defaults', {})
    create_resources('logstash::lumberjack', hiera_hash('ducktape::logstash::lumberjacks', {}), $logstash_lumberjack_defaults)
  }

}

