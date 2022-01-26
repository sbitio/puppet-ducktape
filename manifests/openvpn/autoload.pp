class ducktape::openvpn::autoload (
  Boolean $load_servers,
  Boolean $load_clients,
  Boolean $load_revokes,
) {

  if $load_servers {
    create_resources('::openvpn::server', $ducktape::openvpn::servers, $ducktape::openvpn::server_defaults)
  }

  if $load_clients {
    create_resources('::openvpn::client', $ducktape::openvpn::clients, $ducktape::openvpn::client_defaults)
  }

  if $load_revokes {
    create_resources('::openvpn::revoke', $ducktape::openvpn::revokes, $ducktape::openvpn::revoke_defaults)
  }

}
