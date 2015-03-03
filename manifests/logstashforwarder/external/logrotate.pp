class ducktape::logstashforwarder::external::logrotate(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    logrotate::rule { 'logstash-forwarder':
      path          => [
        '/var/log/logstash-forwarder',
      ],
      sharedscripts => true,
      postrotate    => $::osfamily ? {
        Debian => 'invoke-rc.d logstash-forwarder force-reload > /dev/null',
        RedHat => '/sbin/service logstash-forwarder force-reload > /dev/null 2>&1 || :'
      },
      create        => true,
      create_mode   => 640,
      create_owner  => 'root',
      create_group  => 'adm',
    }
  }

}

