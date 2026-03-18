class ducktape::fail2ban (
  Boolean $enabled = true,
  Hash $actions = {},
  Hash $action_defaults = {},
  Hash $filters = {},
  Hash $filter_defaults = {},
  Hash $jails = {},
  Hash $jail_defaults = {},
) {
  if $enabled {
    require ducktape::fail2ban::autoload
  }
}
