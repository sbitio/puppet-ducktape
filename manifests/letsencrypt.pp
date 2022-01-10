class ducktape::letsencrypt (
  $enabled = true,
  Hash $certonly_defaults = {},
  Hash $certonlys = {},
) {

  validate_bool($enabled)

  if $enabled {
    include ducktape::letsencrypt::autoload
  }

}
