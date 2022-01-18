class ducktape::alternatives (
  Boolean $enabled = true,
  Hash $defaults = {},
  Hash $alternatives = {},
) {

  if $enabled {
    contain ducktape::alternatives::autoload
  }

}
