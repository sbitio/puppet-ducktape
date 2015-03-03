class ducktape::logstashforwarder::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    monit::check::service { 'logstash-forwarder':
      pidfile => '/var/run/logstash-forwarder.pid',
      binary  => '/opt/logstash-forwarder/bin/logstash-forwarder',
    }
  }

}

