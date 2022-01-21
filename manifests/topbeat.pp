class ducktape::topbeat(
  Boolean $enabled = true,
) {

  if $enabled {
    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::topbeat::external::monit
    }
  }

}
