class ducktape::rsyslog (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {

    # External configs.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::rsyslog::external::monit
    }
  }

}

