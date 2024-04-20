class ducktape::logstash (
  Boolean $enabled = true,
  Hash $configfile_defaults = {},
  Hash $configfiles = {},
  Hash $patternfile_defaults = {},
  Hash $patternfiles = {},
  Hash $plugin_defaults = {},
  Hash $plugins = {},
) {
  if $enabled {
    include ducktape::logstash::autoload

    # External configs.
    if defined('monit') and defined(Class['monit']) {
      include ducktape::logstash::external::monit
    }
  }
}
