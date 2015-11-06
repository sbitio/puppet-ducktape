class ducktape::sudo::autoload (
  $autoload             = true,
  $hiera_merge_strategy = hiera_hash,
) {

  validate_bool($autoload)

  if $autoload {
    $conf_defaults = hiera('ducktape::sudo::conf::defaults', {})
    if ($hiera_merge_strategy == 'hiera_hash') {
      $confs = hiera_hash('ducktape::sudo::confs', {})
    }
    else {
      $confs = hiera('ducktape::sudo::confs', {})
    }
    create_resources('::sudo::conf', $confs, $conf_defaults)
  }

}

