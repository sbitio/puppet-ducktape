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

    if versioncmp($::varnish::varnish_version, '4.0') >= 0 {
      $config = [
        'group varnish',
        'env.varnishstat varnishstat',
        'env.name',
      ]
      if versioncmp($::varnish::varnish_version, '5.0') >= 0 {
        $varnish_plugin = 'varnish5_'
        $source = 'puppet:///modules/ducktape/varnish/external/munin_node_plugin/varnish5_'
      }
      else {
        $varnish_plugin = 'varnish4_'
        $source = 'puppet:///modules/ducktape/varnish/external/munin_node_plugin/varnish4_'
      }
    }
    else {
      $varnish_plugin = 'varnish_'
    }
    @munin::node::plugin { $varnish_plugin :
      config    => $config,
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
      source    => $source,
    }
  }
}

