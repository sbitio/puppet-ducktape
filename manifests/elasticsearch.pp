class ducktape::elasticsearch (
  Boolean $enabled = true,
) {

  if $enabled {

    # External configs.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::elasticsearch::external::monit
    }
  }

}
