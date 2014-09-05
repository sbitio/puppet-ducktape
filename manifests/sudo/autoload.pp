class ducktape::sudo::autoload (
  $autoload = true,
) {

  validate_bool($autoload)

  if $autoload {
    $conf_defaults = hiera('ducktape::sudo::conf::defaults', {})
    $confs         = hiera('ducktape::sudo::confs', {})
    create_resources('::sudo::conf', $confs, $conf_defaults)
  }

}

