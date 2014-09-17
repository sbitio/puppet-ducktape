class ducktape::puppetdb(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::puppetdb::external::monit
    }
  }

}

