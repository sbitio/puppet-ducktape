define ducktape::letsencrypt::external::icinga2::check(
  $domains = [$title],
  $defaults = $::ducktape::letsencrypt::icinga2_check_params,
) {
  #TODO# Check all domains.
  $domain = $domains[0]

  $vars = {
    ssl_cert_address => $domain,
    ssl_cert_cn      => $domain,
  }
  $params = {
    check_command => 'ssl_cert',
    vars          => $vars,
    host_name     => $::fqdn,
    apply         => true,
    assign        => [ "host.name == $::fqdn" ],
  }
  $deep = deep_merge($params, $defaults)
  notify {"DEEP MERGED SERVICE $deep":}

  @@icinga2::object::service { "ssl_cert_${name}":
    * => deep_merge($params, $defaults)
  }
}
