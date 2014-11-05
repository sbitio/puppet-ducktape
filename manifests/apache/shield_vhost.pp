class ducktape::apache::shield_vhost (
  $enabled  = true,
  $ensure   = present,
  $port     = 80,
  $docroot  = $::apache::docroot,
  $priority = '10',
) {
  if $enabled {
    #TODO# Ensure this works in Apache 2.4 (like Ubuntu 14)
    #See# http://httpd.apache.org/docs/2.4/upgrading.html
    apache::vhost{ 'shield' :
      ensure      => $ensure,
      port        => $port,
      docroot     => $docroot,
      access_log  => false,
      error_log   => false,
      priority    => $priority,
      override    => [ 'None' ],
      directories => [ 
        { path           => $docroot,
          order          => 'allow,deny',
          deny           => 'from all', 
          options        => [ 'None' ],
          allow_override => [ 'None' ],
        }, 
      ],
    }
  }
}
