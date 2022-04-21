class ducktape::redis::external::monit(
  Boolean $enabled = true,
  String  $action  = 'restart',
  Hash $conn_tolerance = { cycles => 1 },
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {

  if $enabled {
    if $::redis::default_install {
      $connection_test = {
        type     => 'connection',
        port     => $::redis::port,
        protocol => 'GENERIC',
        protocol_test => [
          {
            send => "\"SETEX monit_redis-server_${::hostname} 10 'monit'\\r\\n\"",
            expect => '"OK|-MOVED .*"',
          },
          {
            send => "\"EXISTS monit_redis-server_${::hostname} 10 'monit'\\r\\n\"",
            expect => '":1|-CROSSSLOT .*"',
          },
        ],
        action => $action,
        tolerance => $conn_tolerance,
      }
      monit::check::service { 'redis-server':
        group   => 'redis',
        pidfile => '/var/run/redis/redis-server.pid',
        binary  => '/usr/bin/redis-server',
        tests   => [ $connection_test, ],
      }
    }
    else {
      $::redis::instances.each |$name, $instance| {
        $_real_bind = $instance['bind'] ? {
          undef => '0.0.0.0',
          default => $instance['bind'],
        }
        $connection_test = {
          type     => 'connection',
          port     => $instance['port'],
          protocol => 'GENERIC',
          protocol_test => [
            {
              send => "\"SETEX monit_redis-server_${::hostname}_${name} 10 'monit'\\r\\n\"",
              expect => '"OK|-MOVED .*"',
            },
            {
              send => "\"EXISTS monit_redis-server_${::hostname}_${name} 10 'monit'\\r\\n\"",
              expect => '":1|-CROSSSLOT .*"',
            },
          ],
          action => 'restart',
        }
        monit::check::service { "redis-server-${name}":
          group         => 'redis',
          # We use matching since pid behaviour is erratic
          matching      => "/usr/bin/redis-server ${_real_bind}:${instance['port']}",
          binary        => '/usr/bin/redis-server',
          systemd_file  => "/etc/systemd/system/redis-server-${name}.service",
          tests         => [ $connection_test, ],
          restart_limit => $restart_limit,
        }
      }
    }
  }
}
