class ducktape::systemd::autoload (
  Boolean $load_dropin_files = true,
  Boolean $load_unit_files = true,
) {

  validate_bool($load_dropin_files)
  validate_bool($load_unit_files)

  if $load_dropin_files {
    $systemd_dropin_files_defaults = hiera('ducktape::systemd::dropin_files::defaults', {})
    create_resources('::systemd::dropin_file', hiera_hash('ducktape::systemd::dropin_files', {}), $systemd_dropin_files_defaults)
  }

  if $load_unit_files {
    $systemd_unit_files_defaults = hiera('ducktape::systemd::unit_files::defaults', {})
    create_resources('::systemd::unit_file', hiera_hash('ducktape::systemd::unit_files', {}), $systemd_unit_files_defaults)
  }

}

