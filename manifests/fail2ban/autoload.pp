class ducktape::fail2ban::autoload (
  Boolean $load_actions = true,
  Boolean $load_filters = true,
  Boolean $load_jails = true,
) {
  if $load_actions {
    create_resources('fail2ban::action', $ducktape::fail2ban::actions, $ducktape::fail2ban::action_defaults)
  }
  if $load_filters {
    create_resources('fail2ban::filter', $ducktape::fail2ban::filters, $ducktape::fail2ban::filter_defaults)
  }
  if $load_jails {
    create_resources('fail2ban::jail', $ducktape::fail2ban::jails, $ducktape::fail2ban::jail_defaults)
  }
}
