class ducktape::archive (
  Boolean $enabled,
  Hash $defaults,
  Hash $archives,
) {

  if $enabled {
    require ducktape::archive::autoload
  }

}
