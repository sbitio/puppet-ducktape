class ducktape::filebeat(
  Boolean $enabled = true,
) {

  if $enabled {
    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::filebeat::external::monit
    }
  }

}
