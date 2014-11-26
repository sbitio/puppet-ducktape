class ducktape::haproxy::autoload (
  $load_frontends = true,
  $load_backends  = true,
) {

  validate_bool($load_frontends)
  validate_bool($load_backends)

  if $load_frontends {
    $haproxy_frontend_defaults = hiera('ducktape::haproxy::frontend::defaults', {})
    create_resources('haproxy::frontend', hiera_hash('ducktape::haproxy::frontends', {}), $haproxy_frontend_defaults)
  }

  if $load_backends {
    $haproxy_backend_defaults = hiera('ducktape::haproxy::backend::defaults', {})
    create_resources('haproxy::backend', hiera_hash('ducktape::haproxy::backends', {}), $haproxy_backend_defaults)
  }

}

