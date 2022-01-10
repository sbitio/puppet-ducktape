class ducktape::apache::autoload (
  Boolean $autoload = true,
) {

  if $autoload {
    create_resources('::ducktape::apache::conf', $ducktape::apache::confs, $ducktape::apache::conf_defaults)
  }

}
