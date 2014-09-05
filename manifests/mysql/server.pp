class ducktape::mysql::server inherits ducktape::mysql {
  if $enabled {
    if $flavour == 'percona' {
      # We want the pid inside this folder (Debian/RedHat default).
      file { '/var/run/mysqld':
        ensure  => directory,
        owner   => 'mysql',
        mode    => 755,
        require => Class['::mysql::server::install'],
        notify  => Class['::mysql::server::service']
      }
    }
    anchor { 'ducktape::mysql::server::begin': } ->
      Class['::ducktape::mysql::flavour'] ->
      Class['::mysql::server::install'] ->
    anchor { 'ducktape::mysql::server::end': }
  }
}

