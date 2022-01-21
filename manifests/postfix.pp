class ducktape::postfix(
  boolean $enabled = true,
  Hash $config_defaults = {},
  Hash $configs = {},
) {

  if $enabled {
    include ducktape::postfix::autoload

    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::postfix::external::monit
    }
  }

}
