class ducktape::haproxy::latest (
  Boolean $enabled = true,
) {

  if $enabled {
    case $::operatingsystem {
      'Ubuntu' : {
        case $::lsbdistcodename {
          'trusty' : {
            # Based on http://haproxy.debian.net/
            include apt
            apt::ppa { 'ppa:vbernat/haproxy-1.5': }
            -> Class['::haproxy::install']
          }
        }
      }
    }
  }

}
