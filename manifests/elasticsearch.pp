class ducktape::elasticsearch (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {

    # External configs.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::elasticsearch::external::monit
    }
  }

}

