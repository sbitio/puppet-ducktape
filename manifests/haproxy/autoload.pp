class ducktape::haproxy::autoload (
  Boolean $frontend           = true,
  Hash    $frontend_defaults  = {},
  Hash    $frontends          = {},
  Boolean $backend            = true,
  Hash    $backend_defaults   = {},
  Hash    $backends           = {},
  Boolean $peer               = true,
  Hash    $peers              = {},
  Boolean $userlist           = true,
  Hash    $userlist_defaults  = {},
  Hash    $userlists          = {},
) {

  if $frontend {
    create_resources('haproxy::frontend', $frontends, $frontend_defaults)
  }

  if $backend {
    create_resources('haproxy::backend', $backends, $backend_defaults)
  }

  if $peer {
    if $peers != {} {
      haproxy::peers { 'peerlist': }
      $peer_defaults = {
        peers_name => 'peerlist'
      }
      create_resources('haproxy::peer', $peers, $peer_defaults)
    }
  }

  if $userlist {
    create_resources('haproxy::userlist', $userlists, $userlist_defaults)
  }
}

