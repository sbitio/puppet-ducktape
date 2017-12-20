class ducktape::letsencrypt (
  $enabled = true,
  $icinga2_check_enabled = true,
  $icinga2_check_params = {
    vars => {
      ssl_cert_critical => 7,
      ssl_cert_altnames => true,
    },
    groups => [],
  },
) {

  validate_bool($enabled)

  if $enabled {
    include ducktape::letsencrypt::autoload
  }

}

