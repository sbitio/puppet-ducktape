class ducktape::archive (
  Boolean $enabled = true,
  Hash $defaults = {},
  Hash $archives = {},
) {
  if $enabled {
    require ducktape::archive::autoload
  }
}
