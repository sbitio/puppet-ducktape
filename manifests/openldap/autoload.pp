class ducktape::openldap::autoload(
  $load_accesses = true,
  $load_indexes = true,
  $load_modules = true,
  $load_overlays = true,
  $load_schemas = true,
) {

  validate_bool($load_accesses)
  validate_bool($load_indexes)
  validate_bool($load_modules)
  validate_bool($load_overlays)
  validate_bool($load_schemas)

  if $load_accesses {
    $access_defaults = hiera('ducktape::openldap::server::access_defaults', {})
    $accesses = hiera_hash('ducktape::openldap::server::accesses', {})
    create_resources('openldap::server::access', $accesses, $access_defaults)
  }

  if $load_modules {
    $module_defaults = hiera('ducktape::openldap::server::module_defaults', {})
    $modules = hiera_hash('ducktape::openldap::server::modules', {})
    create_resources('openldap::server::module', $modules, $module_defaults)
  }

  if $load_overlays {
    $overlay_defaults = hiera('ducktape::openldap::server::overlay_defaults', {})
    $overlays = hiera_hash('ducktape::openldap::server::overlays', {})
    create_resources('openldap::server::overlay', $overlays, $overlay_defaults)
  }

  if $load_indexes {
    $index_defaults = hiera('ducktape::openldap::server::dbindex_defaults', {})
    $indexes = hiera_hash('ducktape::openldap::server::dbindexes', {})
    create_resources('openldap::server::dbindex', $indexes, $index_defaults)
  }

  if $load_schemas {
    $schema_defaults = hiera('ducktape::openldap::server::schema_defaults', {})
    $schemas = hiera_hash('ducktape::openldap::server::schemas', {})
    create_resources('openldap::server::schema', $schemas, $schema_defaults)
  }

}
