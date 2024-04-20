class ducktape::tomcat::external::monit (
  Boolean $enabled = true,
  String  $action  = 'restart',
  Hash $conn_tolerance = { cycles => 1 },
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {
  if $enabled {
    $init_system = $facts['os']['name'] ? {
      'Ubuntu' => $facts['os']['distro']['release']['major'] ? {
        /(12\.|14\.)/ => 'sysv',
        default       => undef,
      },
      'Debian' => $facts['os']['distro']['codename'] ? {
        'jessie' => 'sysv',
        default  => undef,
      },
      default  => undef,
    }
    $pidfile = $facts['os']['family'] ? {
      'Debian' => "/var/run/${tomcat::service_name}.pid",
      'RedHat' => $facts['os']['distro']['release']['major'] ? {
        7       => undef,
        default => '/var/run/tomcat6.pid',
      },
    }
    $matching = $facts['os']['family'] ? {
      'Debian' => undef,
      'RedHat' => $facts['os']['distro']['release']['major'] ? {
        7       => '/usr/share/tomcat',
        default => undef,
      },
    }
    $bin = $tomcat::java_home ? {
      undef   => "${tomcat::default_java_home}/bin/java",
      default => "${tomcat::java_home}/bin/java",
    }

    $connection_test = {
      type     => 'connection',
      protocol => 'http',
      port     => $tomcat::http_port,
      action   => $action,
      tolerance => $conn_tolerance,
    }

    monit::check::service { $tomcat::service_name :
      init_system   => $init_system,
      pidfile       => $pidfile,
      matching      => $matching,
      binary        => $bin,
      tests         => [$connection_test],
      require       => Class['tomcat::service'],
      restart_limit => $restart_limit,
    }
  }
}
