class ducktape::gluster (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ducktape::gluster::autoload
  }

}

