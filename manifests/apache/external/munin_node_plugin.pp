class ducktape::apache::external::munin_node_plugin (
  $enabled        = true,
  $ip             = '127.0.0.1',
  $port           = 80,
  $vhost_priority = 99,
  $vhost_seed     = 'munin-apache',
  $vhost_prefix   = 'munin-apache-',
  $vhost_suffix   = ".${::fqdn}",
) {

  validate_bool($enabled)
  #TODO# Add more validations

  if $enabled {
    #TODO# Add mod_status

    $rand_fragment = fqdn_rand(1000000, $vhost_seed)
    $servername    = "${vhost_prefix}${rand_fragment}${vhost_suffix}"
    $docroot       = "/var/www/${servername}"

    $_location = {
      path           => $::apache::mod::status::status_path,
      provider       => 'location',
      options        => [ 'None' ],
      allow_override => [ 'None' ],
    }
    if versioncmp($::apache::apache_version, '2.4') >= 0 {
      $_directory_version = {
        require => 'ip 127.0.0.1',
      }
    } else {
      $_directory_version = {
        order => 'allow,deny',
        deny  => 'from all',
        allow => 'from 127.0.0.1'
      }
    }
    $_directories = [
      merge($_location, $_directory_version),
    ]

    apache::vhost { $servername:
      port              => $port,
      docroot           => $docroot,
      options           => [ 'None' ],
      priority          => $vhost_priority,
      access_log_pipe   => '/dev/null',
      access_log_format => '-',
      error_log_pipe    => '/dev/null',
      directories       => $_directories,
    }
    host { $servername:
      ip => $ip,
    }

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
          "env.url http://${servername}:${port}/${::apache::mod::status::status_path}?auto",
        ],
      },
    }

    ensure_resource('munin::node::plugin::required_package', $required_packages)

    @munin::node::plugin { $plugins :
      required_packages => $required_packages,
      require           => [
        Service[$apache::params::service_name],
        Package[$required_packages],
      ],
    }
  }
}
