class ducktape::ntp(
  Boolean $enabled,
) {

  if $enabled {
    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::ntp::external::monit
    }
  }

}
