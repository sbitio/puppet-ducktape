class ducktape::haproxy::external::munin_node_plugin (
  $enabled = true,
  $ensure  = $::haproxy::package_ensure,
  $url     = 'http://127.0.0.1:8000/haproxy/haproxy-status;csv;norefresh'
) {

  validate_bool($enabled)

  if $enabled {
    case $::osfamily {
      debian : {
        $required_packages = 'libio-all-lwp-perl'
      }
      redhat : {
        $required_packages = 'perl-LWP-Authen-Negotiate'
      }
      default: {
        fail("Unsupported platform: ${::osfamily}")
      }
    }
    # TODO: add stdlib requirement
    #@munin::node::plugin::required_package { $required_packages :
    #   ensure => $ensure,
    #   # TODO: add stdlib as dependency
    #   tag    => 'haproxy_',
    #}
    ensure_resource(
      'munin::node::plugin::required_package',
      $required_packages,
      {
        ensure => $ensure,
      }
    )
    # TODO: add tag Munin::Node::pl
    @munin::node::plugin { 'haproxy_' :
      ensure  => $ensure,
      sufixes => [
        'stats',
      ],
      config  => $url ? {
        undef   => undef,
        default => [
          "env.url ${url}",
        ],
      },
      require => [
        # Upstream module doesn't have service as available variable
        Class['::haproxy::service'],
        Package[$required_packages],
      ],
    }
    @munin::node::plugin { 'haproxy_ng' :
      ensure  => $ensure,
      config  => $url ? {
        undef   => undef,
        default => [
          "env.url ${url}",
        ],
      },
      require => [
        # Upstream module doesn't have service as available variable
        Class['::haproxy::service'],
        Package[$required_packages],
      ],
    }
  }
}
