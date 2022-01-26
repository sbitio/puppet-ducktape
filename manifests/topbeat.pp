class ducktape::topbeat(
  Boolean $enabled,
) {

  if $enabled {
    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::topbeat::external::monit
    }
  }

}
