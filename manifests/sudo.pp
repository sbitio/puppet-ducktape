class ducktape::sudo (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    require ::ducktape::sudo::defaults
    require ::ducktape::sudo::autoload
  }

}
