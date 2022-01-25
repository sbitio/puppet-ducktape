class ducktape::postfix::autoload (
  Boolean $load_configs,
) {

  if $load_configs {
    create_resources('postfix::config', $ducktape::postfix::configs, $ducktape::postfix::config_defaults)
  }

}
