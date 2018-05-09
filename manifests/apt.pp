class ducktape::apt (
  $enabled = true,
  $force_apt_update_before_packages = true,
) {

  validate_bool($enabled)

  if $enabled {
    # Declare keys.
    $key_defaults = hiera('ducktape::apt::key::defaults', {})
    $keys = hiera_hash('ducktape::apt::keys', {})
    create_resources('::apt::key', $keys, $key_defaults)

    # Declare sources.
    $source_defaults = hiera('ducktape::apt::source::defaults', {})
    $sources = hiera_hash('ducktape::apt::sources', {})
    create_resources('::apt::source', $sources, $source_defaults)
  }

  if ($force_apt_update_before_packages) {
    Class['apt::update'] -> Package <||>
  }
}

