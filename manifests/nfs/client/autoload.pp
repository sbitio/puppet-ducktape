class ducktape::nfs::client::autoload (
  Boolean $autorealize = true,
  String $nfstag      = 'nfs',
  Boolean $load_mounts = true,
) {

  if $load_mounts {
    create_resources('nfs::client::mount', $ducktape::nfs::client::mounts, $ducktape::nfs::client::mount_defaults)
  }
  if $autorealize {
    Nfs::Client::Mount <<| nfstag == $nfstag |>>
  }

}
