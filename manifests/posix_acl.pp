class ducktape::posix_acl (
  Boolean $enabled = true,
  Hash $defaults = {},
  Hash $acls = {},
) {

  if $enabled {

    require ::ducktape::posix_acl::autoload

  }

}
