class ducktape::gluster::autoload (
  Boolean $load_mounts,
) {

  if $load_mounts {
    create_resources('gluster::mount', $ducktape::gluster::mounts, $ducktape::gluster::mount_defaults)
  }

}
