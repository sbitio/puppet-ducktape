class ducktape::mysql::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $connection_test = {
      type => connection,
      host => '127.0.0.1',
      port => 3306,
    }
    monit::check::service { "$::mysql::server::service_name":
      pidfile => $::mysql::params::pidfile,
      binary  => $::osfamily ? {
        'Debian' => '/usr/sbin/mysqld',
        default  => undef,
      },
      tests   => [$connection_test, ],
      #TODO# if 5 restarts within 5 cycles then timeout
    }
  }

}

