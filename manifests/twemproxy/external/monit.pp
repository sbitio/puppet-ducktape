class ducktape::twemproxy::external::monit(
  Boolean $enabled = true,
  String $action = 'restart',
  Hash $conn_tolerance = { cycles => 1 },
  Boolean $test_redis = true,
  Integer $test_redis_port = 22122,
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {

  if $enabled {
    if $test_redis {
      # We need to know key length forehand, sha256 produces 64 bytes lenthgs
      $redis_key = sha256("twemproxy_${hostname}")
      $connection_test = {
        type     => 'connection',
        port     => $test_redis_port,
        protocol => 'GENERIC',
        protocol_test => [
          {
            send => "\"*4\\r\\n\$5\\r\\nSETEX\\r\\n\$64\\r\\n${redis_key}\\r\\n\$2\\r\\n10\\r\\n\$64\\r\\n${redis_key}\\r\\n\"",
            expect => '"OK"',
          },
          {
            send => "\"*2\\r\\n\$6\\r\\nEXISTS\\r\\n\$64\\r\\n${redis_key}\\r\\n\"",
            expect => '":1"',
          },
        ],
        action    => $action,
        tolerance => $conn_tolerance,
      }
    }
    monit::check::service { 'nutcracker':
      matching      => 'nutcracker',
      init_system   => 'sysv',
      restart_limit => $restart_limit,
      tests         => $connection_test ? {
        undef => undef,
        default => [ $connection_test, ],
      }
    }
  }
}
