class ducktape::apache::autoload (
  Boolean $autoload,
) {

  if $autoload {
    create_resources('::ducktape::apache::conf', $ducktape::apache::confs, $ducktape::apache::conf_defaults)
  }

}
