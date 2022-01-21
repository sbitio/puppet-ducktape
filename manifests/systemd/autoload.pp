class ducktape::systemd::autoload (
  Boolean $load_dropin_files = true,
  Boolean $load_unit_files = true,
  Boolean $load_timers = true,
  Boolean $load_networks = true,
) {

  if $load_dropin_files {
    create_resources('::systemd::dropin_file', $ducktape::systemd::dropin_files, $ducktape::systemd::dropin_file_defaults)
  }

  if $load_unit_files {
    create_resources('::systemd::unit_file', $ducktape::systemd::unit_files, $ducktape::systemd::unit_file_defaults)
  }

  if $load_timers {
    create_resources('::systemd::timer', $ducktape::systemd::timers, $ducktape::systemd::timer_defaults)
  }

  if $load_networks {
    create_resources('::systemd::network', $ducktape::systemd::networks, $ducktape::systemd::network_defaults)
  }
}
