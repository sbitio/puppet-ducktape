class ducktape::sudo (
  Boolean $enabled = true,
  Hash $conf_defaults = {},
  Hash $confs = {},
) {

  if $enabled {
    require ::ducktape::sudo::defaults
    require ::ducktape::sudo::autoload
  }

}
