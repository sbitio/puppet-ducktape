class ducktape::php::autoload (
  Boolean $autoload = true,
) {

  if $autoload {

    $config   = merge({'config' => $ducktape::php::confs}, $ducktape::php::defaults)
    ensure_resource('ducktape::php::conf', 'overrides', $config)

  }

}
