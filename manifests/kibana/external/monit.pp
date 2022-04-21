class ducktape::kibana::external::monit(
  Boolean $enabled  = true,
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {

  if $enabled {
    monit::check::service { 'kibana':
      binary        => '/usr/share/kibana/bin/../node/bin/node',
      matching      => 'kibana',
      systemd_file  => '/etc/systemd/system/kibana.service',
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
