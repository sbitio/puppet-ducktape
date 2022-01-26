class ducktape::postgresql(
  Boolean $enabled,
) {

  if $enabled {
    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::postgresql::external::monit
    }
  }

}
