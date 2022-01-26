class ducktape::kibana (
  Boolean $enabled,
) {

  if $enabled {
    # External configs.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::kibana::external::monit
    }
  }

}
