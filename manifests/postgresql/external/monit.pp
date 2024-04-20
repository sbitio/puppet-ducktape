class ducktape::postgresql::external::monit (
  Boolean $enabled = true,
  String  $action  = 'restart',
  Hash $conn_tolerance = { cycles => 1 },
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {
  if $enabled {
    $connection_test = {
      type   => 'connection',
      host   => '127.0.0.1',
      port   => 5432,
      action => $action,
      tolerance => $conn_tolerance,
    }
    $pg_bin = "${postgresql::params::bindir}/postgres"
    monit::check::service { $postgresql::server::service_name:
      matching      => $pg_bin,
      binary        => $pg_bin,
      tests         => [$connection_test,],
      restart_limit => $restart_limit,
    }
  }
}
