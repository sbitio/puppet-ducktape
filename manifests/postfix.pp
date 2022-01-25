class ducktape::postfix(
  Boolean $enabled,
  Hash $config_defaults,
  Hash $configs,
) {

  if $enabled {
    include ducktape::postfix::autoload

    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::postfix::external::monit
    }
  }

}
