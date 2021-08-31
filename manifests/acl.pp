class ducktape::acl (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {

    $acl_defaults = hiera('ducktape::acl::defaults', {})
    create_resources('posix_acl', hiera_hash('ducktape::acls', {}), $acl_defaults)

  }

}
