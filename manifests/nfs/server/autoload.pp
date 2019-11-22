class ducktape::nfs::server::autoload (
  $load_exports = true,
) {

  validate_bool($load_exports)

  if $load_exports {
    $nfs_server_export_defaults = lookup('ducktape::nfs::server::export::defaults', {'default_value' => {}})
    create_resources('nfs::server::export', hiera_hash('ducktape::nfs::server::exports', {}), $nfs_server_export_defaults)
  }

}

