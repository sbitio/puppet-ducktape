class ducktape::archive (
  $enabled = true,
  Hash $defaults = {},
  Hash $archives = {},
) {

  validate_bool($enabled)

  if $enabled {

    require ducktape::archive::autoload

  }

}
