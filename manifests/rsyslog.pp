class ducktape::rsyslog (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {

    include ducktape::rsyslog::autoload

    # External configs.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::rsyslog::external::monit
    }
  }

}

