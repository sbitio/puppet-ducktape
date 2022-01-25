class ducktape::kibana::external::monit(
  Boolean $enabled,
) {

  if $enabled {
    monit::check::service { 'kibana':
      binary       => '/usr/share/kibana/bin/../node/bin/node',
      matching     => 'kibana',
      systemd_file => '/etc/systemd/system/kibana.service',
      tests        => [
        {
          type => 'connection',
          host => '127.0.0.1',
          port => '5601',
        },
      ],
    }
  }

}
