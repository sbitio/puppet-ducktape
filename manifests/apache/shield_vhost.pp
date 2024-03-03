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
      require        => 'all denied',
    }
    $_location = {
      path           => '/.*',
      provider       => 'locationmatch',
      options        => [ 'None' ],
      allow_override => [ 'None' ],
      require        => 'all denied',
    }

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
      directories     => [
        $_directory,
        $_location,
      ],
    }
  }

}
