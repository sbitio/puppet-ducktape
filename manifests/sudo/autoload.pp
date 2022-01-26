class ducktape::sudo::autoload (
  Boolean $autoload,
) {

  if $autoload {
    create_resources('::sudo::conf', $ducktape::sudo::confs, $ducktape::sudo::conf_defaults)
  }

}
