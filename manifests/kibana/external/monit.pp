class ducktape::kibana::external::monit (
  Boolean $enabled  = true,
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {
  if $enabled {
    $systemd_file = (versioncmp($kibana::ensure, '8') <= 0) ? {
      true    => '/etc/systemd/system/kibana.service',
      default => '/usr/lib/systemd/system/kibana.service',
    }
    monit::check::service { 'kibana':
      binary        => '/usr/share/kibana/bin/../node/bin/node',
      matching      => 'kibana',
      systemd_file  => $systemd_file,
      restart_limit => $restart_limit,
      tests         => [
        {
          type => 'connection',
          host => '127.0.0.1',
          port => '5601',
        },
      ],
    }
  }
}
