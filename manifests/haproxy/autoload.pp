class ducktape::haproxy::autoload (
  Boolean $load_frontends = true,
  Boolean $load_backends  = true,
  Boolean $load_peers     = true,
  Boolean $load_userlists = true,

  Boolean $http_edge                 = true,
  String  $http_edge_path            = '/opt/http-edge',
  String  $http_edge_path_owner      = 'root',
  String  $http_edge_frontend        = 'default_fe',

  Hash    $http_edge_markers         = { 'redirects' => '###http-edge-redirects###',
                                         'canonicals' => '###http-edge-canonicals###',
                                         'nofollow' => '###http-edge-nofollow###',
                                         'status410' => '###http-edge-status410###' },
  Array   $http_edge_redirect_types  = [ 'str', 'beg', 'end', 'sub', 'dir', 'regm' ],
  Array   $http_edge_services        = [ 'redirects' ],
  Hash    $http_edge_domains_envs    = {},
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

      $http_edge_rules_all_placeholder = $http_edge_services.map | $service | {
        $http_edge_rules = flatten($http_edge_domains_envs.map |$domain, $options| {
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

            if $service in $options['_services'] {

              ensure_resource('file', [$path_env, "$path_env/current", "$path_env/current/$service"], $file_args)

              $http_edge_redirect_types.map |$type| {
                $map_file = "$path_env/current/$service/$domain.$type.map"
                $map_func = "map_$type"

                file { $map_file:
                  ensure => present,
                  owner => $http_edge_path_owner,
                }
                if $service == 'redirects' {
                  "redirect location %[path,$map_func($map_file)] code 301 if { ${hdr_match}(host) -i $domain_env } { path,$map_func($map_file) -m found } !{ path,$map_func($map_file) -m str haproxy-skip }"
                } elsif $service == 'nofollow' {
                  "set-var(txn.noindex) always_true if { ${hdr_match}(host) $domain_env } { path,$map_func($map_file) -m found }"
                } elsif $service == 'status410' {
                  "set-var(txn.status410) always_true if { ${hdr_match}(host) $domain_env } { path,$map_func($map_file) -m found }"
                } elsif $service == 'canonicals' {
                  "set-header X-Canonical-Custom <https://%[${hdr_match}(host)]%[url,$map_func($map_file)]>;\\ rel=\"canonical\" if !{ req.hdr(X-Canonical-Custom) -m found } { ${hdr_match}(host) $domain_env } { url,$map_func($map_file) -m found }"
                }

              }
            }
          }
        })
        [$service, $http_edge_rules]
      }

      $http_edge_rules_all = Hash($http_edge_rules_all_placeholder)
      # Filter undef fields from the http-edge rules
      $http_edge_rules_all_real_without_undef = $http_edge_rules_all.map |$key, $value| {
        $real_rules = $value.filter |$rules| { $rules =~ NotUndef }
        [$key, $real_rules]
      }
      $http_edge_rules_all_real = Hash($http_edge_rules_all_real_without_undef)

      # Insert additional http-edge rules that are service specific
      if 'canonicals' in $http_edge_services or 'status410' in $http_edge_services or or 'nofollow' in $http_edge_services {
        if 'canonicals' in $http_edge_services {
          $http_edge_canonicals_rules_real = flatten($http_edge_rules_all_real['canonicals'], 'set-var(txn.canonical_custom) hdr(X-Canonical-Custom) if { hdr(X-Canonical-Custom) -m found }', 'del-header X-Canonical-Custom if { hdr(X-Canonical-Custom) -m found }')
        }
        $http_response_rules = $ducktape::haproxy::frontends[$http_edge_frontend]['options']['http-response']
        $http_response_new_rules = $http_edge_services.map | $service | {
          if $service == 'canonicals' {
            'set-header link %[var(txn.canonical_custom)] if { var(txn.canonical_custom) -m found }'
          } elsif $service == 'status410' {
            'set-status 410 if { var(txn.status410) -m bool }'
          } elsif $service == 'nofollow' {
            'set-header X-Robots-Tag "noindex, nofollow" if { var(txn.noindex) -m bool }'
          }
        }
        $http_response_new_rules_real = $http_response_new_rules.filter |$rules| { $rules =~ NotUndef }
        $http_response_rules_real = concat($http_response_rules, $http_response_new_rules_real)
        $http_response_rules_hash = {$http_edge_frontend => {'options' => {'http-response' => $http_response_rules_real}}}
      }

      # Insert http-edge rules at the marker position, or at the end if no marker
      $http_request_rules = $ducktape::haproxy::frontends[$http_edge_frontend]['options']['http-request']
      if 'redirects' in $http_edge_services and grep($http_request_rules, $http_edge_markers['redirects']) == [] {
        $http_request_rules_with_redirects = concat($http_request_rules, $http_edge_rules_all_real['redirects'])
      }
      elsif 'redirects' in $http_edge_services {
        $http_request_rules_with_redirects = split(regsubst(join($http_request_rules, "\n"), $http_edge_markers['redirects'], join($http_edge_rules_all_real['redirects'], "\n")), "\n")
      } else {
        $http_request_rules_with_redirects = $http_request_rules
      }

      if 'status410' in $http_edge_services and grep($http_request_rules_with_redirects, $http_edge_markers['status410']) == [] {
        $http_request_rules_with_status410 = concat($http_request_rules_with_redirects, $http_edge_rules_all_real['status410'])
      }
      elsif 'status410' in $http_edge_services {
        $http_request_rules_with_status410 = split(regsubst(join($http_request_rules_with_redirects, "\n"), $http_edge_markers['status410'], join($http_edge_rules_all_real['status410'], "\n")), "\n")
      } else {
        $http_request_rules_with_status410 = $http_request_rules_with_redirects
      }

      if 'nofollow' in $http_edge_services and grep($http_request_rules_with_status410, $http_edge_markers['nofollow']) == [] {
        $http_request_rules_with_nofollow = concat($http_request_rules_with_status410, $http_edge_rules_all_real['nofollow'])
      }
      elsif 'nofollow' in $http_edge_services {
        $http_request_rules_with_nofollow = split(regsubst(join($http_request_rules_with_status410, "\n"), $http_edge_markers['nofollow'], join($http_edge_rules_all_real['nofollow'], "\n")), "\n")
      } else {
        $http_request_rules_with_nofollow = $http_request_rules_with_status410
      }

      if 'canonicals' in $http_edge_services and grep($http_request_rules_with_nofollow, $http_edge_markers['canonicals']) == [] {
        $http_request_rules_real = concat($http_request_rules_with_nofollow, $http_edge_canonicals_rules_real)
      }
      elsif 'canonicals' in $http_edge_services {
        $http_request_rules_real = split(regsubst(join($http_request_rules_with_nofollow, "\n"), $http_edge_markers['canonicals'], join($http_edge_canonicals_rules_real, "\n")), "\n")
      } else {
        $http_request_rules_real = $http_request_rules_with_nofollow
      }

      $http_request_rules_hash = {$http_edge_frontend => {'options' => {'http-request' => $http_request_rules_real}}}
      if 'canonicals' in $http_edge_services or 'status410' in $http_edge_services or 'nofollow' in $http_edge_services {
        $frontends_real_placeholder = deep_merge($ducktape::haproxy::frontends, $http_request_rules_hash)
        $frontends_real = deep_merge($frontends_real_placeholder, $http_response_rules_hash)
      } else {
        $frontends_real = deep_merge($ducktape::haproxy::frontends, $http_request_rules_hash)
      }
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
