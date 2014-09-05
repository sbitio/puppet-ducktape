class ducktape::php (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $defaults = hiera('ducktape::php::conf::defaults', {})
    $confs    = hiera_hash('ducktape::php::confs', {})
    $config   = merge({'config' => $confs}, $defaults)
    ensure_resource('ducktape::php::conf', 'overrides', $config)
  }

}

