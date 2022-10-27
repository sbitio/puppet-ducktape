class ducktape::apache::shield_vhost (
  Boolean $enabled = true,
  Enum['present', 'absent'] $ensure = 'present',
  Variant[Integer, Array[Integer]] $port = 8008,
  Stdlib::Absolutepath $docroot = $::apache::docroot,
  String $priority = '10',
  Optional[String] $custom_fragment = undef,
) {

  if $enabled {

    $_directory = {
      path           => $docroot,
      options        => [ 'None' ],
      allow_override => [ 'None' ],
    }
    $_location = {
      path           => '/.*',
      provider       => 'locationmatch',
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
      add_listen      => false,
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
