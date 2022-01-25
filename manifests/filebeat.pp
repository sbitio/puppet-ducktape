class ducktape::filebeat(
  Boolean $enabled,
) {

  if $enabled {
    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::filebeat::external::monit
    }
  }

}
