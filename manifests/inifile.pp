class ducktape::inifile (
  Boolean $enabled  = true,
  Hash $settings = {},
  Hash $defaults = {},
) {

  if $enabled {
    require ducktape::inifile::autoload
  }
}
