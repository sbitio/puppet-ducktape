class ducktape::mysql::external::monit(
  Boolean $enabled = true,
  String  $action  = 'restart',
  Hash $conn_tolerance = { cycles => 1 },
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {

  if $enabled {
    $init_system = $::operatingsystem ? {
      'Ubuntu' => $::lsbmajdistrelease ? {
        /(12\.|14\.)/ => 'sysv',
        default       => undef,
      },
      'Debian' => $::lsbdistcodename ? {
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
    monit::check::service { $::mysql::server::service_name:
      init_system   => $init_system,
      pidfile       => $::mysql::params::pidfile,
      binary        => $::osfamily ? {
        'Debian' => '/usr/sbin/mysqld',
        'Redhat' => $::lsbmajdistrelease ? {
          7       => '/usr/libexec/mysqld',
          default => '/usr/sbin/mysqld',
        },
        default  => undef,
      },
      tests         => [$connection_test, ],
      restart_limit => $restart_limit,
    }
  }

}
