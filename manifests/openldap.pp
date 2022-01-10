class ducktape::openldap (
  Boolean $enabled = true,
  Hash $access_defaults = {},
  Hash $accesses = {},
  Hash $module_defaults = {},
  Hash $modules = {},
  Hash $overlay_defaults = {},
  Hash $overlays = {},
  Hash $index_defaults = {},
  Hash $indexes = {},
  Hash $schema_defaults = {},
  Hash $schemas = {},
) {

  if $enabled {
    include ducktape::openldap::server::autoload

    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::openldap::server::external::monit
    }
  }

}
