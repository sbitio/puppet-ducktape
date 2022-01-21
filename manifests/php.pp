class ducktape::php (
  Boolean $enabled = true,
) {

  if $enabled {
    $defaults = hiera('ducktape::php::conf::defaults', {})
    $confs    = hiera_hash('ducktape::php::confs', {})
    $config   = merge({'config' => $confs}, $defaults)
    ensure_resource('ducktape::php::conf', 'overrides', $config)
  }

}
