class ducktape::gluster::autoload (
  $load_mounts = true,
) {

  validate_bool($load_mounts)

  if $load_mounts {
    create_resources('gluster::mount', $ducktape::gluster::mounts, $ducktape::gluster::mount_defaults)
  }

}
