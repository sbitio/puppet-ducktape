class ducktape::openvpn::autoload (
  $load_servers = true,
  $load_clients = true,
  $load_revokes = true,
) {

  validate_bool($load_servers)
  validate_bool($load_clients)
  validate_bool($load_revokes)

  if $load_servers {
    $server_defaults = hiera('ducktape::openvpn::server::defaults', {})
    create_resources('::openvpn::server', hiera_hash('ducktape::openvpn::servers', {}), $server_defaults)
  }

  if $load_clients {
    $client_defaults = hiera('ducktape::openvpn::client::defaults', {})
    create_resources('::openvpn::client', hiera_hash('ducktape::openvpn::clients', {}), $client_defaults)
  }

  if $load_revokes {
    $revoke_defaults = hiera('ducktape::openvpn::revoke::defaults', {})
    create_resources('::openvpn::revoke', hiera_hash('ducktape::openvpn::revokes', {}), $revoke_defaults)
  }

}

