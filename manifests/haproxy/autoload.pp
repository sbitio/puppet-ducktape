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
  Boolean $http_edge                = true,
  String  $http_edge_path           = '/opt/http-edge',
  String  $http_edge_path_owner     = 'deploy',
  String  $http_edge_frontend       = 'default_fe',
  Array   $http_edge_redirect_types = [ 'str', 'beg', 'end', 'sub', 'dir', 'regm' ],
  Hash    $http_edge_domains_envs   = {},
) {

  if $frontend {

    if $http_edge {
      file {$http_edge_path:
        ensure => directory,
        owner => $http_edge_path_owner,
        mode => "2755"
      }
      $http_edge_domains_envs.each |$key,$value| {
        $value.each |$env,$domain| {
          $path_exists = find_file("${http_edge_path}/${env}")
          unless $path_exists {
            file { ["${http_edge_path}/${env}",
                    "${http_edge_path}/${env}/current",
                    "${http_edge_path}/${env}/current/redirects",]:
              ensure => directory,
              owner => $http_edge_path_owner,
              replace => false
            }
          }
          $http_edge_redirect_types.each |$type| {
            file {"${http_edge_path}/${env}/current/redirects/${key}.${type}.map":
              ensure => present,
              owner => $http_edge_path_owner,
              replace => false
            }
          }
        }
      }
      $rules = $http_edge_domains_envs.map |$key,$value| {
        $value.map |$env,$domain| {
          $http_edge_redirect_types.map |$type| {
            $http_edge_real_path = "${http_edge_path}/${env}/current/redirects/${key}.${type}.map"
            "redirect location %[path,map_${type}(${http_edge_real_path})] code 301 if { hdr(host) -i ${domain} } { path,map_${type}(${http_edge_real_path}) -m found } !{ path,map_${type}(${http_edge_real_path}) -m str haproxy-skip }"
          }
        }
      }
      $http_request_rules = {$http_edge_frontend => {'options'=> {'http-request'=> concat($frontends[$http_edge_frontend][options][http-request],flatten($rules))}}}
      $frontends_real = deep_merge($frontends, $http_request_rules)
    } else {
      $frontends_real = $frontends
    }

    create_resources('haproxy::frontend', $frontends_real, $frontend_defaults)
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
