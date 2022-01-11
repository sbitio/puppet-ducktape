class ducktape::nfs::client::autoload (
  Boolean $autorealize = true,
  String $nfstag      = 'nfs',
  Boolean $load_mounts = true,
) {

  if $load_mounts {
    $nfs_client_mount_defaults = hiera('ducktape::nfs::client::mount::defaults', {})
    create_resources('nfs::client::mount', hiera_hash('ducktape::nfs::client::mounts', {}), $nfs_client_mount_defaults)
  }
  if $autorealize {
    Nfs::Client::Mount <<| nfstag == $nfstag |>>
  }

}
