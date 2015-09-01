class ducktape::opendkim (
  $enabled = true,
  $port    = 8891,
) {

  validate_bool($enabled)

  if $enabled {
    include ::ducktape::opendkim::autoload

    # External
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::opendkim::external::monit
    }
    if defined('::postfix') and defined(Class['::postfix']) {
      include ::ducktape::opendkim::external::postfix
    }
  }

}

