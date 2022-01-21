class ducktape::postfix::autoload (
  $load_configs = true,
) {

  validate_bool($load_configs)

  if $load_configs {
    create_resources('postfix::config', $ducktape::postfix::configs, $ducktape::postfix::config_defaults)
  }

}
