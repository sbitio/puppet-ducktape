class ducktape::opendkim (
  Boolean $enabled = true,
  Integer $port    = 8891,
  Hash $domain_defaults = {},
  Hash $domains = {},
  Hash $trusted_defaults = {},
  Hash $trusteds = {},
) {

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
