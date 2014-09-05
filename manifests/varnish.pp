class ducktape::varnish (
  $enabled    = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ::ductape::varnish::vcl
    include ::ductape::varnish::secret
  }

}
