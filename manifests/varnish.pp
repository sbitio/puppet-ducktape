class ducktape::varnish (
  $enabled    = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ::ducktape::varnish::vcl
    include ::ducktape::varnish::secret
  }

}
