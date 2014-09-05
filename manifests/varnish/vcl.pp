class ducktape::varnish::vcl (
  $enabled    = true,
  $vcl_name   = $::hostname,
  $vcl_source = undef,
) {

  validate_bool($enabled)
  validate_string($vcl_name)

  if $enabled {
    if $vcl_source != undef {
      validate_string($vcl_source)
      file { "/etc/varnish/${vcl_name}.vcl" :
        ensure => $::varnish::version ? {
          absent  => absent,
          default => present,
        },
        source => $vcl_source,
        notify => Class['::varnish::service'],
      }
    }
  }

}
