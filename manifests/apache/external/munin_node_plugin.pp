class ducktape::apache::external::munin::node::plugin (
  $enabled    = true,
  $port       = 80,
  $ip         = "127.0.0.1",
) {

  validate_bool($enabled)
  #TODO# Add more validations

  if $enabled {
    #TODO# Add mod_status

    case $::osfamily {
      debian : {
        $required_packages = 'libio-all-lwp-perl'
      }
      redhat : {}
      default: {
        fail("Unsupported platform: ${::osfamily}")
      }
    }

    $plugins = [
      'apache_accesses',
      'apache_processes',
      'apache_volume',
    ]

    @munin::node::plugin::conf { 'apache' :
      ensure => $ensure,
      config => {
        'apache_*' => [
          "env.url http://${ip}:${port}/server-status?auto",
        ],
      },
    }

    @munin::node::plugin::required_package { $required_packages :
      ensure => $ensure,
      tag    => $plugins,
    }

    @munin::node::plugin { $plugins :
      ensure    => $ensure,
      required_packages => $required_packages,
      require   => [
        Service[$apache::params::service_name],
        Package[$required_packages],
      ],
    }
  }
}
