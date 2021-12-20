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
  Boolean $http_edge                 = true,
  String  $http_edge_path            = '/opt/http-edge',
  String  $http_edge_path_owner      = 'root',
  String  $http_edge_frontend        = 'default_fe',

  String  $http_edge_redirect_marker = '###http-edge-redirects###',
  Array   $http_edge_redirect_types  = [ 'str', 'beg', 'end', 'sub', 'dir', 'regm' ],
  Hash    $http_edge_domains_envs    = {},
) {

  if $frontend {
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
        $options['_envs'].map |$env| {
          $path_env = "${http_edge_path}/${env}"
          if $options[$env] {
            $domain_env = $options[$env]
          }
          else {
            $parts = [$options['_domain_prefix'], $env, $options['_domain_suffix']].filter |$item| { !$item.empty }
            $domain_env = join($parts, '.')
          }

          ensure_resource('file', [$path_env, "$path_env/current", "$path_env/current/redirects"], $file_args)

          $http_edge_redirect_types.map |$type| {
            $map_file = "$path_env/current/redirects/$domain.$type.map"
            $map_func = "map_$type"
            file { $map_file:
              ensure => present,
              owner => $http_edge_path_owner,
            }
            "redirect location %[path,$map_func($map_file)] code 301 if { hdr(host) -i $domain_env } { path,$map_func($map_file) -m found } !{ path,$map_func($map_file) -m str haproxy-skip }"
          }
        }
      })

      # Insert http-edge redirect rules at the marker position, or at the end if no marker
      $http_request_rules = $frontends[$http_edge_frontend]['options']['http-request']
      if grep($http_request_rules, $http_edge_redirect_marker) == [] {
        $http_request_rules_real = concat($http_request_rules, $http_edge_redirect_rules)
      }
      else {
        $http_request_rules_real = split(regsubst(join($http_request_rules, "\n"), $http_edge_redirect_marker, join($http_edge_redirect_rules, "\n")), "\n")
      }

      $http_request_rules_hash = {$http_edge_frontend => {'options' => {'http-request' => $http_request_rules_real}}}
      $frontends_real = deep_merge($frontends, $http_request_rules_hash)
    }
    else {
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
