class ducktape::openldap::server::autoload(
  Boolean $load_accesses,
  Boolean $load_indexes,
  Boolean $load_modules,
  Boolean $load_overlays,
  Boolean $load_schemas,
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
