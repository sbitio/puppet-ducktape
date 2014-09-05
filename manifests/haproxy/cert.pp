define ducktape::haproxy::cert (
  $source,
  $ensure    = present,
  $cert_path = '/etc/haproxy/certs',
) {
  # TODO add stdlib dependency
  # TODO param validation

  if ! defined_with_params(File[$cert_path], { 'ensure' => 'directory' }) {
    file { $cert_path:
      ensure  => directory,
    }
  }
  file { "${cert_path}/${name}":
    ensure => $ensure,
    source => $source,
    # Fixed string since service name is not a variable in main module
    notify => Service['haproxy'],
  }
}

