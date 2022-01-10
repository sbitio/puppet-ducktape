class ducktape::logrotate (
  Boolean $enabled = true,
  Hash $rule_defaults = {},
  Hash $rules = {},
) {

  if $enabled {
    include ducktape::logrotate::autoload
  }

}
