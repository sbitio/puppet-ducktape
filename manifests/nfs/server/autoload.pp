class ducktape::nfs::server::autoload (
  Boolean $load_exports = true,
) {

  if $load_exports {
    create_resources('nfs::server::export', $ducktape::nfs::server::exports, $ducktape::nfs::server::export_defaults)
  }

}
