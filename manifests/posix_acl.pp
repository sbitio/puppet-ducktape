class ducktape::posix_acl (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {

    $posix_acl_defaults = hiera('ducktape::posix_acl::defaults', {})
    create_resources('posix_acl', hiera_hash('ducktape::posix_acls', {}), $posix_acl_defaults)

  }

}
