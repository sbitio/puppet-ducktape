class ducktape::ssh(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    # External checks.
    if defined('::ssh') and defined(Class['::ssh']) {
      include ::ducktape::ssh::external::monit
    }
  }

}

