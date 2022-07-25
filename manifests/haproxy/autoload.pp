class ducktape::haproxy::autoload (
  Boolean $load_frontends = true,
  Boolean $load_backends  = true,
  Boolean $load_peers     = true,
  Boolean $load_userlists = true,

  Boolean $http_edge                 = true,
  String  $http_edge_path            = '/opt/http-edge',
  String  $http_edge_path_owner      = 'root',
  String  $http_edge_frontend        = 'default_fe',

  String  $http_edge_redirect_marker = '###http-edge-redirects###',
  Array   $http_edge_redirect_types  = [ 'str', 'beg', 'end', 'sub', 'dir', 'regm' ],
  Hash    $http_edge_domains_envs    = {},
) {

  if $load_frontends {
    $frontends_real = $http_edge ? {
      true => ducktape::haproxy_http_edge($http_edge_path, $http_edge_path_owner, $http_edge_frontend, $http_edge_redirect_marker, $http_edge_redirect_types, $http_edge_domains_envs),
      false => $ducktape::haproxy::frontends,
    }

    create_resources('haproxy::frontend', $frontends_real, $ducktape::haproxy::frontend_defaults)
  }

  if $load_backends {
    create_resources('haproxy::backend', $ducktape::haproxy::backends, $ducktape::haproxy::backend_defaults)
  }

  if $load_peers {
    if $ducktape::haproxy::peers != {} {
      haproxy::peers { 'peerlist': }
      $peer_defaults = {
        peers_name => 'peerlist'
      }
      create_resources('haproxy::peer', $ducktape::haproxy::peers, $peer_defaults)
    }
  }

  if $load_userlists {
    create_resources('haproxy::userlist', $ducktape::haproxy::userlists, $ducktape::haproxy::userlist_defaults)
  }
}
