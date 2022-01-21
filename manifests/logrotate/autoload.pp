class ducktape::logrotate::autoload (
  Boolean $load_rules = true,
) {

  if $load_rules {
    create_resources('logrotate::rule', $ducktape::logrotate::rules, $ducktape::logrotate::rule_defaults)
  }

}
