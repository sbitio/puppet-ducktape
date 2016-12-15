class ducktape::letsencrypt (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ducktape::letsencrypt::autoload
  }

}

