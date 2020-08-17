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
) {

  validate_bool($enabled)

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
