class ducktape::sonarqube (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ducktape::sonarqube::autoload
  }

}

