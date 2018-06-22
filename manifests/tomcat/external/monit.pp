class ducktape::tomcat::external::monit (
  $enabled = true,
  $action  = 'restart',
) {

  if $enabled {

    $init_system = $::operatingsystem ? {
      'Ubuntu' => $::lsbmajdistrelease ? {
        /(12\.|14\.)/ => 'sysv',
        default       => undef,
      },
      'Debian' => $::lsbdistcodename ? {
        'jessie' => 'sysv',
        default  => undef,
      },
      default  => undef,
    }
    $pidfile = $::osfamily ? {
      'Debian' => "/var/run/${::tomcat::service_name}.pid",
      'RedHat' => $::lsbmajdistrelease ? {
        7       => undef,
        default => '/var/run/tomcat6.pid',
      },
    }
    $matching = $::osfamily ? {
      'Debian' => undef,
      'RedHat' => $::lsbmajdistrelease ? {
        7       => '/usr/share/tomcat',
        default => undef,
      },
    }
    $bin = $::tomcat::java_home ? {
      undef   => "${::tomcat::default_java_home}/bin/java",
      default => "${::tomcat::java_home}/bin/java",
    }

    $connection_test = {
      type     => 'connection',
      protocol => 'http',
      port     => $::tomcat::http_port,
      action   => $action,
    }

    monit::check::service { $::tomcat::service_name :
      init_system => $init_system,
      pidfile     => $pidfile,
      matching    => $matching,
      binary      => $bin,
      tests       => [ $connection_test ],
      require     => Class['::tomcat::service'],
    }
  }
}

