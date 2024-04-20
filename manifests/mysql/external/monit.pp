class ducktape::mysql::external::monit (
  Boolean $enabled = true,
  String  $action  = 'restart',
  Hash $conn_tolerance = { cycles => 1 },
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {
  if $enabled {
    $init_system = $facts['os']['name'] ? {
      'Ubuntu' => $facts['os']['distro']['release']['major'] ? {
        /(12\.|14\.)/ => 'sysv',
        default       => undef,
      },
      'Debian' => $facts['os']['distro']['codename'] ? {
        'jessie' => 'sysv',
        default  => undef,
      },
      default  => undef,
    }
    $connection_test = {
      type   => 'connection',
      host   => '127.0.0.1',
      port   => 3306,
      action => $action,
      tolerance => $conn_tolerance,
    }
    $binary = $facts['os']['family'] ? {
      'Debian' => '/usr/sbin/mysqld',
      'Redhat' => $facts['os']['distro']['release']['major'] ? {
        7       => '/usr/libexec/mysqld',
        default => '/usr/sbin/mysqld',
      },
      default  => undef,
    }
    monit::check::service { $mysql::server::service_name:
      init_system   => $init_system,
      pidfile       => $mysql::params::pidfile,
      binary        => $binary,
      tests         => [$connection_test,],
      restart_limit => $restart_limit,
    }
  }
}
