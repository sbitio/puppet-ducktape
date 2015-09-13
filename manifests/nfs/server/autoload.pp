class ducktape::nfs::server::autoload (
  $load_exports = true,
) {

  validate_bool($load_exports)

  if $load_exports {
    $nfs_server_export_defaults = hiera('ducktape::nfs::server::export::defaults', {})
    create_resources('nfs::server::export', hiera_hash('ducktape::nfs::server::exports', {}), $nfs_server_export_defaults)
  }

}

