define ducktape::logstash::lumberjack (
  $enabled = true,
  $port,
  $cert,
  $key,
) {

  validate_bool($enabled)
  #TODO# validate port, cert, key

  $ssl_dir = '/etc/logstash/lumberjack'
  $cert_filename = "${ssl_dir}/${port}.crt"
  $key_filename = "${ssl_dir}/${port}.key"
  if $enabled {
    file { $ssl_dir :
      ensure => directory
    }
    file { $cert_filename :
      ensure => present,
      source => $cert,
    }
    file { $key_filename :
      ensure => present,
      source => $key,
    }
    logstash::configfile { 'input_lumberjack_${port}':
      content => template('ducktape/logstash/lumberjack.erb')
    }
  }

}

