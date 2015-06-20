class ducktape::logstashforwarder::external::logrotate(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    logrotate::rule { 'logstash-forwarder':
      path          => [
        '/var/log/logstash-forwarder.log',
        '/var/log/logstash-forwarder.err',
        '/var/log/logstash-forwarder/logstash-forwarder.log',
        '/var/log/logstash-forwarder/logstash-forwarder.err',
      ],
      sharedscripts => true,
      postrotate    => $::osfamily ? {
        Debian => 'invoke-rc.d logstash-forwarder restart > /dev/null',
        RedHat => '/sbin/service logstash-forwarder restart > /dev/null 2>&1 || :'
      },
      create        => true,
      create_mode   => 640,
      create_owner  => 'root',
      create_group  => 'adm',
      missingok     => true,
      rotate        => 52,
      rotate_every  => 'week',
    }
  }

}

