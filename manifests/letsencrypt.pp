class ducktape::letsencrypt (
  Boolean $enabled,
  Hash $certonly_defaults,
  Hash $certonlys,
) {

  if $enabled {
    include ducktape::letsencrypt::autoload
  }

}
