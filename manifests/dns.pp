class ducktape::dns (
  Boolean $enabled = true,
) {

  if $enabled {
    include ducktape::dns::autoload
  }

}
