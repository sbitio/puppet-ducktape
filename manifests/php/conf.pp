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
      ini_setting { $name:
        path    => $php_config_file,
        section => '',
        setting => '; priority',
        value   => $priority,
        before  => Php::Config[$name],
      }
      php::config { $name:
        file    => $php_config_file,
        config  => $config,
        require => Class['::php::packages'],
      }
    }
    absent: {
      file { $php_config_file:
        ensure => absent,
      }
    }
  }

  # Ubuntu/Debian systems use the mods-available folder. We need to enable
  # settings files ourselves with php5enmod command.
  # See https://github.com/Mayflower/puppet-php/blob/master/manifests/extension.pp#L101
  if $::osfamily == 'Debian' {
    $cmd = "${::php::params::ext_tool_enable} ${name}"
    exec { $cmd:
      refreshonly => true,
    }
    Ini_Setting[$name] ~> Exec[$cmd]
    Php::Config[$name] ~> Exec[$cmd]
  }
}

