class ducktape::mysql (
  Boolean $enabled = true,
  Optional[String] $flavour = undef,
) {

  if $enabled {
    class { '::ducktape::mysql::flavour' :
      flavour => $flavour,
    }
  }

}
