class ducktape::mysql::server::autoload (
  $load_plugins = true,
) {

  validate_bool($load_plugins)

  if $load_plugins {
    $plugin_defaults = hiera('ducktape::mysql::server::plugins::defaults', {})
    $plugins         = hiera_hash('ducktape::mysql::server::plugins', {})
    create_resources('mysql_plugin', $plugins, $plugin_defaults)
  }

}
