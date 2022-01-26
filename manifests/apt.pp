class ducktape::apt (
  Boolean $enabled,
  Hash $key_defaults,
  Hash $keys,
  Hash $source_defaults,
  Hash $sources,
) {

  if $enabled {
    contain ducktape::apt::autoload
  }

}
