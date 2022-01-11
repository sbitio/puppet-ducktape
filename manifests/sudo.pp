class ducktape::sudo (
  Boolean $enabled = true,
) {

  if $enabled {
    require ::ducktape::sudo::defaults
    require ::ducktape::sudo::autoload
  }

}
