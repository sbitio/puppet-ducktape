define ducktape::php::conf(
  $ensure   = present,
  $priority = '99',
  $config   = {},
) {
#TODO# Add $sapi = [] param. If not empty, limit this config to the given SAPI list.

  validate_re($ensure, '^(present|absent)$',
  "${ensure} is not supported for ensure.
  Allowed values are 'present' and 'absent'.")
  validate_hash($config)

  $php_config_file = "${::php::params::config_root_ini}/${name}.ini"

  case $ensure {
    present: {
      php::config { $name:
        file    => $php_config_file,
        config  => $config,
        require => Class['::php::packages'],
        before  => File_line[$name],
      }
      file_line { $name:
        path  => $php_config_file,
        line  => "; priority=${priority}",
        match => '^; priority=',
      }
    }
    absent: {
      file { $file:
        ensure => absent,
      }
    }
  }

  # Ubuntu/Debian systems use the mods-available folder. We need to enable
  # settings files ourselves with php5enmod command.
  # See https://github.com/Mayflower/puppet-php/blob/master/manifests/extension.pp#L101
  if $::osfamily == 'Debian' {
    $cmd = "php5enmod ${name}"
    exec { $cmd:
      refreshonly => true,
    }
    File_line[$name] ~> Exec[$cmd]
    Php::Config[$name] ~> Exec[$cmd]
  }
}

