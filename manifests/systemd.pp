class ducktape::systemd (
  Boolean $enabled = true,
  Optional[Enum[
    'emerg',
    'alert',
    'crit',
    'err',
    'warning',
    'notice',
    'info',
    'debug'
    ]] $logging_level,
  Hash $dropin_file_defaults = {},
  Hash $dropin_files = {},
  Hash $unit_file_defaults = {},
  Hash $unit_files = {},
  Hash $timer_defaults = {},
  Hash $timers = {},
  Hash $network_defaults = {},
  Hash $networks = {},
) {

  if $enabled {
    include ducktape::systemd::autoload

    if $logging_level {
      ['system', 'user'].each |String $instance| {
        ini_setting { "systemd-${instance}-loglevel":
          path              => "/etc/systemd/${instance}.conf",
          section           => 'Manager',
          key_val_separator => '=',
          setting           => 'LogLevel',
          value             => $logging_level,
          notify            => Class[systemd::systemctl::daemon_reload],
        }
      }
    }
  }

}
