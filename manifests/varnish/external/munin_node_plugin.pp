class ducktape::varnish::external::munin_node_plugin(
  $enabled = true,
) {
  if $enabled {
    case $::osfamily {
      debian : {
        $required_packages = 'librpc-xml-perl'
      }
      redhat : {
        $required_packages = []
      }
      default: {
        fail("Unsupported platform: ${::osfamily}")
      }
    }
    ensure_resource('munin::node::plugin::required_package', $required_packages)

    @munin::node::plugin { 'varnish_' :
      ensure    => $ensure,
      sufixes   => [
        'backend_traffic',
        'bad',
        'expunge',
        'hit_rate',
        'memory_usage',
        'objects',
        'request_rate',
        'threads',
        'transfer_rates',
        'uptime',
      ],
      require   => [
        Class['::varnish::service'],
        Package[$required_packages],
      ],
    }
  }
}

