class ducktape::logstash::autoload (
  Boolean $load_configfiles  = true,
  Boolean $load_patternfiles = true,
  Boolean $load_plugins      = true,
) {

  if $load_configfiles {
    create_resources('logstash::configfile', $ducktape::logstash::configfiles, $ducktape::logstash::configfile_defaults)
  }

  if $load_patternfiles {
    create_resources('logstash::patternfile', $ducktape::logstash::patternfiles, $ducktape::logstash::patternfile_defaults)
  }

  if $load_plugins {
    create_resources('logstash::plugin', $ducktape::logstash::plugins, $ducktape::logstash::plugin_defaults)
  }

}
