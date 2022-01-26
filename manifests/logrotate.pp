class ducktape::logrotate (
  Boolean $enabled,
  Hash $rule_defaults,
  Hash $rules,
) {

  if $enabled {
    include ducktape::logrotate::autoload
  }

}
