class ducktape::varnish::secret (
  $enabled = true,
  $secret  = undef,
) {

  validate_bool($enabled)

  if $enabled {
    if $secret != undef {
      validate_string($secret)
      file { $::varnish::varnish_secret_file :
        ensure => $::varnish::version ? {
          absent  => absent,
          default => present,
        },
        content => "${secret}\n",
        notify => Class['::varnish::service'],
      }
    }
  }

}
