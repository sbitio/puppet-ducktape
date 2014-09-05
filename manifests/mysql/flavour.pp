class ducktape::mysql::flavour (
  $flavour,
  $enabled = true,
) {

  validate_bool($enabled)
  validate_string($flavour)

  if $enabled {
    case $flavour {
      'percona' : {
        case $::osfamily {
          'RedHat': {
            yumrepo { 'percona':
              descr    => "CentOS ${::operatingsystemmajrelease} - Percona",
              baseurl  => "http://repo.percona.com/centos/${::operatingsystemmajrelease}/os/${::architecture}/",
              enabled  => 1,
              gpgcheck => 0,
            }
          }
          default : {
            fail("Unsupported platform: ${module_name} currently doesn't support ${::osfamily} or ${::operatingsystem}")
          }
        }
      }
      default : { }
    }
  }

}
