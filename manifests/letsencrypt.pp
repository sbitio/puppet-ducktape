class ducktape::letsencrypt (
  Boolean $enabled = true,
  Hash $certonly_defaults = {},
  Hash $certonlys = {},
) {
  if $enabled {
    include ducktape::letsencrypt::autoload
  }
}
