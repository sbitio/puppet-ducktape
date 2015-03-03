class ducktape::logstashforwarder (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ducktape::logstashforwarder::autoload

    # External configs.
    if defined('::logrotate::base') and defined(Class['::logrotate::base']) {
      include ::ducktape::logstashforwarder::external::logrotate
    }
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::logstashforwarder::external::monit
    }
    if defined('::rsyslog') and defined(Class['::rsyslog']) {
      include ::ducktape::logstashforwarder::external::rsyslog
    }
  }

}

