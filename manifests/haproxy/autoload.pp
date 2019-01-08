class ducktape::haproxy::autoload (
  Boolean $frontend          = true,
  Hash    $frontend_defaults = {},
  Hash    $frontends         = {},
  Boolean $backend           = true,
  Hash    $backend_defaults  = {},
  Hash    $backends          = {},
) {

  if $frontend {
    create_resources('haproxy::frontend', $frontends, $frontend_defaults)
  }

  if $backend {
    create_resources('haproxy::backend', $backends, $backend_defaults)
  }

}

