class ducktape::logstashforwarder::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {

    $init_system = $::operatingsystem ? {
      'Debian' => $::lsbdistcodename ? {
        'jessie' => 'sysv',
        default  => undef,
      },
      default  => undef,
    }

    monit::check::service { 'logstash-forwarder':
      init_system => $init_system,
      pidfile     => '/var/run/logstash-forwarder.pid',
      binary      => '/opt/logstash-forwarder/bin/logstash-forwarder',
    }
  }

}

