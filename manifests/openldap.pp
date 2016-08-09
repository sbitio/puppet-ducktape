class ducktape::openldap (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ducktape::openldap::autoload

    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::openldap::external::monit
    }
  }

}

