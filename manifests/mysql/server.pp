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
    if $::lsbdistcodename == 'wheezy' 
       and defined('::apt_extras::dotdeb')
       and defined(Class[::apt_extras::dotdeb]) 
       and defined('::pam') 
    {
      pam::service_conf { 'su':
        type    => 'session',
        control => 'required',
        module  => 'pam_limits.so',
      }
      file { '/etc/security/limits.d/mysql.conf' :
        ensure => present,
        source => "puppet:///ducktape/mysql/server/wheezy_5.6_limits.conf",
        mode   => 0644,
      }
    }
    anchor { 'ducktape::mysql::server::begin': } ->
      Class['::ducktape::mysql::flavour'] ->
      Class['::mysql::server::install'] ->
    anchor { 'ducktape::mysql::server::end': }
  }
}

