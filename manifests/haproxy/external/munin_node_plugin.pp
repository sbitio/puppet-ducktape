class ducktape::haproxy::external::munin_node_plugin (
  Boolean $enabled = true,
  Stdlib::Ensure::Package $ensure = $haproxy::package_ensure,
  String $url = 'http://127.0.0.1:8000/haproxy/haproxy-status;csv;norefresh'
) {
  if $enabled {
    case $facts['os']['family'] {
      'debian': {
        $required_packages = 'libio-all-lwp-perl'
      }
      'redhat': {
        $required_packages = 'perl-LWP-Authen-Negotiate'
      }
      default: {
        fail("Unsupported platform: ${facts['os']['family']}")
      }
    }
    ensure_resource('munin::node::plugin::required_package', $required_packages)

    # TODO: add tag Munin::Node::pl
    $config1 = $url ? {
      undef   => undef,
      default => [
        "env.url ${url}",
      ],
    }
    @munin::node::plugin { 'haproxy_' :
      ensure  => $ensure,
      sufixes => [
        'stats',
      ],
      config  => $config1,
      require => [
        Class['haproxy'],
        Package[$required_packages],
      ],
    }
    $config2 = $url ? {
      undef   => undef,
      default => [
        "env.url ${url}",
      ],
    }
    @munin::node::plugin { 'haproxy_ng' :
      ensure  => $ensure,
      config  => $config2,
      require => [
        Class['haproxy'],
        Package[$required_packages],
      ],
    }
  }
}
