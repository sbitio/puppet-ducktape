class ducktape::alternatives (
  Boolean $enabled,
  Hash $alternative_defaults,
  Hash $alternatives,
) {

  if $enabled {
    contain ducktape::alternatives::autoload
  }

}
