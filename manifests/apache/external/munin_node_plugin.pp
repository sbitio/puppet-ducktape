class ducktape::apache::external::munin_node_plugin (
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
      redhat : {
        $required_packages = 'perl-libwww-perl'
      }
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
      config => {
        'apache_*' => [
          "env.url http://${ip}:${port}/server-status?auto",
        ],
      },
    }

    ensure_resource('munin::node::plugin::required_package', $required_packages)

    @munin::node::plugin { $plugins :
      required_packages => $required_packages,
      require   => [
        Service[$apache::params::service_name],
        Package[$required_packages],
      ],
    }
  }
}
