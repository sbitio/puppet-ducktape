class ducktape::gluster::autoload (
  $load_mounts = true,
) {

  validate_bool($load_mounts)

  if $load_mounts {
    $gluster_mount_defaults = hiera('ducktape::gluster::mount::defaults', {})
    create_resources('gluster::mount', hiera_hash('ducktape::gluster::mounts', {}), $gluster_mount_defaults)
  }

}

