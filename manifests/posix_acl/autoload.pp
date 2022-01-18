class ducktape::posix_acl::autoload (
  Boolean $autoload = true,
) {

  if $autoload {

    create_resources('posix_acl', $ducktape::posix_acl::acls, $ducktape::posix_acl::defaults)

  }

}
