class ducktape::logstash::external::monit(
  $enabled          = true,
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

    monit::check::service { 'logstash':
      init_system => $init_system,
      pidfile     => '/var/run/logstash.pid',
      binary      => '/usr/bin/java',
      tests       => $ducktape::logstash::external::monit::tests,
      #TODO# if 5 restarts within 5 cycles then timeout
    }
  }

}

