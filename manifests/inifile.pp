class ducktape::inifile (
  $enabled  = true,
  $settings = {},
  $defaults = {},
) {
  create_resources('ini_setting', $settings, $defaults)
}
