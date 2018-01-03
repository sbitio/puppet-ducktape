class ducktape::systemd::autoload (
  $load_dropin_files = true,
) {

  validate_bool($load_dropin_files)

  if $load_dropin_files {
    $systemd_dropin_files_defaults = hiera('ducktape::systemd::dropin_files::defaults', {})
    create_resources('::systemd::dropin_file', hiera_hash('ducktape::systemd::dropin_files', {}), $systemd_dropin_files_defaults)
  }

}

