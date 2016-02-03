class ducktape::sonarqube::autoload (
  $load_plugins = true,
) {

  validate_bool($load_plugins)

  if $load_plugins {
    $sonarqube_plugin_defaults = hiera('ducktape::sonarqube::plugin::defaults', {})
    create_resources('sonarqube::plugin', hiera_hash('ducktape::sonarqube::plugins', {}), $sonarqube_plugin_defaults)
  }

}

