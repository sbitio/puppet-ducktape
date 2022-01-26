class ducktape::ssh(
  Boolean $enabled,
) {

  if $enabled {
    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::ssh::external::monit
    }
  }

}
