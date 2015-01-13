class ducktape::ssh(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::ssh::external::monit
    }
  }

}

