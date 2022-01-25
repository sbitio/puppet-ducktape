class ducktape::puppetdb(
  Boolean $enabled,
) {

  if $enabled {
    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::puppetdb::external::monit
    }
  }

}
