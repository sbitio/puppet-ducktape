class ducktape::tomcat(
  Boolean $enabled = true,
) {

  if $enabled {
    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::tomcat::external::monit
    }
  }

}
