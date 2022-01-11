class ducktape::mysql (
  Boolean $enabled = true,
  String $flavour = undef,
) {

  if $enabled {
    class { '::ducktape::mysql::flavour' :
      flavour => $flavour,
    }
  }

}
