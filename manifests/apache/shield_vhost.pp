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
    if versioncmp($::apache::apache_version, '2.4') >= 0 {
      $_directory_version = {
        require => 'all granted',
      }
    } else {
      $_directory_version = {
        order => 'allow,deny',
        allow => 'from all',
      }
    }
    $_directories = [ merge($_directory, $_directory_version) ]

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

