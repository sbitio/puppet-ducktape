class ducktape::mysql::server::autoload (
  Boolean $conf            = true,
  Hash    $conf_defaults   = {},
  Hash    $confs           = {},
  Boolean $plugin          = true,
  Hash    $plugin_defaults = {},
  Hash    $plugins         = {},
) {

  if $conf {
    create_resources('::ducktape::mysql::conf', $confs, $conf_defaults)
  }
  if $plugin {
    create_resources('mysql_plugin', $plugins, $plugin_defaults)
  }

}
