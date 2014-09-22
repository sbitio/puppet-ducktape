define ducktape::php::conf(
  $ensure   = present,
  $priority = '99',
  $config   = {},
) {

  validate_re($ensure, '^(present|absent)$',
  "${ensure} is not supported for ensure.
  Allowed values are 'present' and 'absent'.")
  validate_hash($config)

  $filename = "${priority}-${name}.ini"
  $php_config_file = "${::php::params::config_root_ini}/${filename}"

  case $ensure {
    present: {
      php::config { $name:
        file    => $php_config_file,
        config  => $config,
        require => Class['::php::packages'],
      }
    }
    absent: {
      file { $file:
        ensure => absent,
      }
    }
  }

  # FIXME: On Ubuntu/Debian systems we use the mods-available folder and have
  # to enable config files ourselves
  # See https://github.com/Mayflower/puppet-php/blob/4aafc92f44beb71f7074b576cf50cf245a690e84/manifests/extension.pp#L89
  if $::osfamily == 'Debian' {
    $symlink = "${::php::params::config_root}/conf.d/${filename}"
    $symlink_ensure = $ensure ? {
      present => link,
      absent  => absent,
    }
    file { $symlink:
      ensure  => $symlink_ensure,
      target  => $php_config_file,
      require => Php::Config[$name],
    }
  } 
}

