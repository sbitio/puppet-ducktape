function ducktape::haproxy_http_edge(
  String  $http_edge_path            = '/opt/http-edge',
  String  $http_edge_path_owner      = 'root',
  String  $http_edge_frontend        = 'default_fe',

  String  $http_edge_redirect_marker = '###http-edge-redirects###',
  Array   $http_edge_redirect_types  = [ 'str', 'beg', 'end', 'sub', 'dir', 'regm' ],
  Hash    $http_edge_domains_envs    = {},
) >> Hash {
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
    $options['_envs'].reduce([]) |$memo, $env| {
      $path_env = "${http_edge_path}/${env}"
      if $options[$env] {
        $domain_env = $options[$env]
      }
      else {
        $parts = [$options['_domain_prefix'], $env, $options['_domain_suffix']].filter |$item| { !$item.empty }
        $domain_env = join($parts, $domain_separator)
      }

      ensure_resource('file', [$path_env, "$path_env/current", "$path_env/current/redirects"], $file_args)

      # Extra rule to add support for query strings. It is a regm match on the url. It is applied for files named after "$domain.url_regm.map".
      # #TODO# This is generalizable to ${fetch}_${matchtype}, being "path" the default fetch (for backwards compatibility) if no underscore is present.
      $type = 'regm'
      $map_file = "$path_env/current/redirects/$domain.url_$type.map"
      $map_func = "map_$type"
      file { $map_file:
        ensure => present,
        owner => $http_edge_path_owner,
      }
      $redirects_url = [
        "redirect location %[url,$map_func($map_file)] code 301 if { ${hdr_match}(host) -i $domain_env } { url,$map_func($map_file) -m found } !{ url,$map_func($map_file) -m str haproxy-skip }"
      ]

      $redirects_path = $http_edge_redirect_types.map |$type| {
        $map_file = "$path_env/current/redirects/$domain.$type.map"
        $map_func = "map_$type"
        file { $map_file:
          ensure => present,
          owner => $http_edge_path_owner,
        }
        $line = "redirect location %[path,$map_func($map_file)] code 301 if { ${hdr_match}(host) -i $domain_env } { path,$map_func($map_file) -m found } !{ path,$map_func($map_file) -m str haproxy-skip }"
        $line
      }

      $memo + $redirects_url + $redirects_path
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

  return $frontends_real
}
