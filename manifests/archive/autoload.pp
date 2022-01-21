class ducktape::archive::autoload (
  Boolean $autoload = true,
) {

  if $autoload {
    create_resources('archive', $ducktape::archive::archives, $ducktape::archive::defaults)
  }

}
