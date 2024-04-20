class ducktape::posix_acl::autoload (
  Boolean $load_acls = true,
) {
  if $load_acls {
    create_resources('posix_acl', $ducktape::posix_acl::acls, $ducktape::posix_acl::acl_defaults)
  }
}
