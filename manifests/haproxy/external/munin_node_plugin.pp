class ducktape::haproxy::external::munin_node_plugin (
  Boolean $enabled,
  $ensure  = $::haproxy::package_ensure,
  String $url,
) {

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
    ensure_resource('munin::node::plugin::required_package', $required_packages)

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
        Class['::haproxy'],
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
        Class['::haproxy'],
        Package[$required_packages],
      ],
    }
  }
}
