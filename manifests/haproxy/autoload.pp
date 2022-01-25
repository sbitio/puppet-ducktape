class ducktape::haproxy::autoload (
  Boolean $load_frontends,
  Boolean $load_backends,
  Boolean $load_peers,
  Boolean $load_userlists,

  Boolean $http_edge,
  String  $http_edge_path,
  String  $http_edge_path_owner,
  String  $http_edge_frontend,

  String  $http_edge_redirect_marker,
  Array   $http_edge_redirect_types,
  Hash    $http_edge_domains_envs,
) {

  if $load_frontends {
    if $http_edge {
      file { $http_edge_path:
        ensure => directory,
        owner => $http_edge_path_owner,
        mode => "2755",
      }

      $file_args = {
        ensure => directory,
        owner => $http_edge_path_owner,
        replace => false,
      }

      $http_edge_redirect_rules = flatten($http_edge_domains_envs.map |$domain, $options| {
        $match_type = pick($options['match_type'], 'str')
        $hdr_match = $match_type ? {
          'str' => 'hdr',
          default => "hdr_${match_type}"
        }
        $domain_separator = $match_type ? {
          'reg' => '\.',
          default => '.',
        }
        $options['_envs'].map |$env| {
          $path_env = "${http_edge_path}/${env}"
          if $options[$env] {
            $domain_env = $options[$env]
          }
          else {
            $parts = [$options['_domain_prefix'], $env, $options['_domain_suffix']].filter |$item| { !$item.empty }
            $domain_env = join($parts, $domain_separator)
          }

          ensure_resource('file', [$path_env, "$path_env/current", "$path_env/current/redirects"], $file_args)

          $http_edge_redirect_types.map |$type| {
            $map_file = "$path_env/current/redirects/$domain.$type.map"
            $map_func = "map_$type"
            file { $map_file:
              ensure => present,
              owner => $http_edge_path_owner,
            }
            "redirect location %[path,$map_func($map_file)] code 301 if { ${hdr_match}(host) -i $domain_env } { path,$map_func($map_file) -m found } !{ path,$map_func($map_file) -m str haproxy-skip }"
          }
        }
      })

      # Insert http-edge redirect rules at the marker position, or at the end if no marker
      $http_request_rules = $ducktape::haproxy::frontends[$http_edge_frontend]['options']['http-request']
      if grep($http_request_rules, $http_edge_redirect_marker) == [] {
        $http_request_rules_real = concat($http_request_rules, $http_edge_redirect_rules)
      }
      else {
        $http_request_rules_real = split(regsubst(join($http_request_rules, "\n"), $http_edge_redirect_marker, join($http_edge_redirect_rules, "\n")), "\n")
      }

      $http_request_rules_hash = {$http_edge_frontend => {'options' => {'http-request' => $http_request_rules_real}}}
      $frontends_real = deep_merge($ducktape::haproxy::frontends, $http_request_rules_hash)
    }
    else {
      $frontends_real = $ducktape::haproxy::frontends
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
