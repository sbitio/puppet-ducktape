class ducktape::inifile (
  Boolean $enabled,
  Hash $settings,
  Hash $defaults,
) {

  if $enabled {
    require ducktape::inifile::autoload
  }
}
