class ducktape::nfs::server::autoload (
  Boolean $load_exports = true,
) {

  if $load_exports {
    $nfs_server_export_defaults = lookup('ducktape::nfs::server::export::defaults', {'default_value' => {}})
    create_resources('nfs::server::export', hiera_hash('ducktape::nfs::server::exports', {}), $nfs_server_export_defaults)
  }

}
