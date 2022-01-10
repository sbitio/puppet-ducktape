class ducktape::openldap::server::autoload(
  Boolean $load_accesses = true,
  Boolean $load_indexes = true,
  Boolean $load_modules = true,
  Boolean $load_overlays = true,
  Boolean $load_schemas = true,
) {

  if $load_accesses {
    create_resources('openldap::server::access', $ducktape::openldap::accesses, $ducktape::openldap::access_defaults)
  }

  if $load_modules {
    create_resources('openldap::server::module', $ducktape::openldap::modules, $ducktape::openldap::module_defaults)
  }

  if $load_overlays {
    create_resources('openldap::server::overlay', $ducktape::openldap::overlays, $ducktape::openldap::overlay_defaults)
  }

  if $load_indexes {
    create_resources('openldap::server::dbindex', $ducktape::openldap::indexes, $ducktape::openldap::index_defaults)
  }

  if $load_schemas {
    create_resources('openldap::server::schema', $ducktape::openldap::schemas, $ducktape::openldap::schema_defaults)
  }

}
