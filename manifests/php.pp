class ducktape::php (
  Boolean $enabled,
  Hash $confs,
  Hash $defaults,
) {

  if $enabled {
    include ducktape::php::autoload
  }

}
