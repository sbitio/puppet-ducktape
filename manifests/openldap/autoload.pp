class ducktape::openldap::autoload(
  $load_accesses = true,
  $load_indexes = true,
  $load_schemas = true,
) {

  validate_bool($load_accesses)
  validate_bool($load_indexes)
  validate_bool($load_schemas)

  if $load_accesses {
    $access_defaults = hiera('ducktape::openldap::server::access_defaults', {})
    $accesses = hiera_hash('ducktape::openldap::server::accesses', {})
    create_resources('openldap::server::access', $accesses, $access_defaults)
  }

  if $load_indexes {
    $index_defaults = hiera('ducktape::openldap::server::index_defaults', {})
    $indexes = hiera_hash('ducktape::openldap::server::indexes', {})
    create_resources('openldap::server::index', $indexes, $index_defaults)
  }

  if $load_schemas {
    $schema_defaults = hiera('ducktape::openldap::server::schema_defaults', {})
    $schemas = hiera_hash('ducktape::openldap::server::schemas', {})
    create_resources('openldap::server::access', $schemas, $schema_defaults)
  }

}
