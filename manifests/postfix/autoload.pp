class ducktape::haproxy::autoload (
  $load_configs = true,
) {

  validate_bool($load_configs)

  if $load_configs {
    $postfix_config_defaults = hiera('ducktape::postfix::config::defaults', {})
    create_resources('postfix::config', hiera_hash('ducktape::postfix::configs', {}), $postfix_config_defaults)
  }

}

