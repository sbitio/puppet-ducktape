class ducktape::alternatives (
  Boolean $enabled = true,
  Hash $alternative_defaults = {},
  Hash $alternatives = {},
) {
  if $enabled {
    contain ducktape::alternatives::autoload
  }
}
