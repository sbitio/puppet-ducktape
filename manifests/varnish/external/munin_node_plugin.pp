class ducktape::varnish::external::munin_node_plugin (
  Boolean $enabled = true,
) {
  if $enabled {
    case $facts['os']['family'] {
      'debian': {
        $required_packages = 'librpc-xml-perl'
      }
      'redhat': {
        $required_packages = []
      }
      default: {
        fail("Unsupported platform: ${facts['os']['family']}")
      }
    }
    ensure_resource('munin::node::plugin::required_package', $required_packages)

    if versioncmp($varnish::varnish_version, '4.0') >= 0 {
      @munin::node::autoconf::exclusion { 'varnish_' : }
      $config = [
        'group varnish',
        'env.varnishstat varnishstat',
      ]
      if versioncmp($varnish::varnish_version, '5.0') >= 0 {
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
      config  => $config,
      sufixes => [
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
      require => [
        Class['varnish::service'],
        Package[$required_packages],
      ],
      source  => $source,
    }
  }
}
