class ducktape::nfs::client::autoload (
  $autorealize = true,
  $load_mounts = true,
) {

  validate_bool($autorealize)
  validate_bool($load_mounts)

  if $load_mounts {
    $nfs_client_mount_defaults = hiera('ducktape::nfs::client::mount::defaults', {})
    create_resources('nfs::client::mount', hiera_hash('ducktape::nfs::client::mounts', {}), $nfs_client_mount_defaults)
  }
  if $autorealize {
    Nfs::Client::Mount <<| |>>
  }

}

