class ducktape::php (
  Boolean $enabled = true,
  Hash $confs = {},
  Hash $defaults = {},
) {

  if $enabled {
    include ducktape::php::autoload
  }

}
