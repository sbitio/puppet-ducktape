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

  Boolean $http_edge          = true,
  String  $http_edge_frontend = 'default_fe',
  String  $http_edge_path     = '/opt/http-edge',
  Array   $http_edge_redirect_types     = [ 'beg', 'dir', 'reg', 'str' ],
  Hash    $http_edge_domains_envs = {},
) {

  if $frontend {

    if $http_edge {

      $rules = $http_edge_domains_envs.map |$key,$value| {
        $value.map |$env,$domain| {
          $http_edge_redirect_types.map |$style| {
            "redirect location %[path,map_str(${http_edge_path}/${env}/current/redirects/${key}.${style}.map)] code 301 if { hdr(host) -i ${domain} } { path,map_str(${http_edge_path}/${env}/current/redirects/${key}.${style}.map) -m found }"
          }
        }
      }

      $http_request_rules = {'default_fe'=> {'options'=> {'http-request'=> concat($frontends[default_fe][options][http-request],flatten($rules))}}}

      $frontends_real = deep_merge($frontends, $http_request_rules)

      create_resources('haproxy::frontend', $frontends_real, $frontend_defaults)

    } else {
      create_resources('haproxy::frontend', $frontends, $frontend_defaults)
    }

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
