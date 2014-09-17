class ducktape::mysql (
  $enabled = true,
  $flavour = undef,
) {

  validate_bool($enabled)
  validate_string($flavour)

  if $enabled {
    class { '::ducktape::mysql::flavour' :
      flavour => $flavour,
    }
  }

}

