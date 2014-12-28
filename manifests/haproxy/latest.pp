class ducktape::haproxy::latest (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    case $::operatingsystem {
      'Ubuntu' : {
        case $::lsbdistcodename {
          'trusty' : {
            # Based on http://haproxy.debian.net/
            apt::ppa { 'ppa:vbernat/haproxy-1.5': }
            -> Class['::haproxy::install']
          }
        }
      }
    }
  }

}

