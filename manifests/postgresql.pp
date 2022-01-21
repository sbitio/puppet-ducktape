class ducktape::postgresql(
  Boolean $enabled = true,
) {

  if $enabled {
    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::postgresql::external::monit
    }
  }

}
