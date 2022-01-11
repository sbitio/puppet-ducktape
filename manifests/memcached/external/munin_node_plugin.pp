class ducktape::memcached::external::munin_node_plugin (
  Boolean $enabled = true,
  $ensure  = $::memcached::package_ensure,
) {

  if $enabled {
    require ::memcached::params
    case $::osfamily {
      debian : {
        $required_packages = 'libcache-memcached-perl'
      }
      redhat : {
        $required_packages = 'perl-Cache-Memcached'
      }
      default: {
        fail("Unsupported platform: ${::osfamily}")
      }
    }
    @munin::node::plugin::required_package { $required_packages :
      ensure => $ensure,
      # TODO: add stdlib as dependency
      tag    => 'memcached_',
    }
    $host = $::memcached::listen_ip ? {
      '0.0.0.0' => '127.0.0.1',
      default   => $::memcached::listen_ip,
    }
    @munin::node::plugin { 'memcached_' :
      ensure  => $ensure,
      sufixes => [
        'rates',
        'bytes',
        'counters',
      ],
      config  => [
        "env.host ${host}",
        "env.port ${::memcached::tcp_port}",
      ],
      require => [
        Service[$::memcached::params::service_name],
        Package[$required_packages],
      ],
    }
  }
}
