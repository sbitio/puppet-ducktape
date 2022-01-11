class ducktape::mysql::flavour (
  String $flavour,
  Boolean $enabled = true,
) {

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
          'Debian': {
            apt::key { 'percona':
              id     => '9334A25F8507EFA5',
              server => 'keys.gnupg.net',
            }
            apt::source { 'percona':
              location => 'http://repo.percona.com/apt',
              release  => $::lsbdistcodename,
              repos    => 'main',
              require  => Apt::Key['percona'],
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
