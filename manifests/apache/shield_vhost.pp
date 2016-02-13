class ducktape::apache::shield_vhost (
  $enabled         = true,
  $ensure          = present,
  $port            = 80,
  $docroot         = $::apache::docroot,
  $priority        = '10',
  $custom_fragment = undef,
) {

  if $enabled {

    $_directory = {
      path           => $docroot,
      options        => [ 'None' ],
      allow_override => [ 'None' ],
    }
    $_location = {
      path           => '/.*',
      provider       => 'location',
      options        => [ 'None' ],
      allow_override => [ 'None' ],
    }
    if versioncmp($::apache::apache_version, '2.4') >= 0 {
      $_directory_version = {
        require => 'all denied',
      }
    } else {
      $_directory_version = {
        order => 'allow,deny',
        deny  => 'from all',
      }
    }
    $_directories = [
      merge($_directory, $_directory_version),
      merge($_location, $_directory_version),
    ]

    apache::vhost{ 'shield' :
      ensure          => $ensure,
      port            => $port,
      docroot         => $docroot,
      access_log      => false,
      error_log       => false,
      priority        => $priority,
      override        => [ 'None' ],
      custom_fragment => "
        <IfModule mod_setenvif.c>
          SetEnvIf Request_Method OPTIONS dontlog
        </IfModule>
        ${custom_fragment}",
      directories     => $_directories,
    }
  }

}

