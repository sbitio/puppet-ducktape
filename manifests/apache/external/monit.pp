class ducktape::apache::external::monit (
  Boolean $enabled = true,
  String $action = 'restart',
  String $ip = '127.0.0.1',
  Integer $port = 80,
  Integer $vhost_priority = 99,
  String $vhost_seed = 'monit-test',
  String $vhost_prefix = 'monit-test-',
  String $vhost_suffix   = ".${facts['networking']['fqdn']}",
  Hash $conn_tolerance = { cycles => 1 },
  Array[String] $alerts         = [],
  Array[Hash] $extra_tests    = [],
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {
  if $enabled {
    $rand_fragment = fqdn_rand(1000000, $vhost_seed)
    $servername    = "${vhost_prefix}${rand_fragment}${vhost_suffix}"
    $docroot       = "/var/www/${servername}"

    # Declare health check vhost.
    file { "${docroot}/index.html":
      content => 'monit-test',
    }
    apache::vhost { $servername:
      port              => $port,
      docroot           => $docroot,
      options           => ['None'],
      priority          => $vhost_priority,
      access_log_pipe   => '/dev/null',
      access_log_format => '-',
      error_log_pipe    => '/dev/null',
    }
    host { $servername:
      ip => $ip,
    }

    # $apache::pidfile declares Debian pidfile as a shell variable.
    # $apache::pidfile declares RedHat pidfile as a relative path.
    $pidfile = $facts['os']['family'] ? {
      'Debian' => $facts['os']['name'] ? {
        'Ubuntu' => (versioncmp($facts['os']['release']['full'], '14.04') < 0) ? {
          true  => '/var/run/apache2.pid',
          false => '/var/run/apache2/apache2.pid',
        },
        'Debian' => (versioncmp($facts['os']['release']['full'], '8') < 0) ? {
          true  => '/var/run/apache2.pid',
          false => '/var/run/apache2/apache2.pid',
        },
        default  => $apache::pidfile,
      },
      'RedHat' => '/var/run/httpd/httpd.pid',
      default  => $apache::pidfile,
    }

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
    $initd           = "${monit::service_program} ${apache::service_name}"
    $program_start   = "/bin/sh -c '${initd} stop || /usr/bin/killall -9 ${apache::service_name} ; /bin/sleep 2 ; ${initd} start'"
    $connection_test = {
      type      => 'connection',
      host      => $servername,
      protocol  => 'http',
      port      => $port,
      action    => $action,
      tolerance => $conn_tolerance,
    }
    monit::check::service { $apache::service_name:
      init_system   => $init_system,
      pidfile       => $pidfile,
      program_start => $program_start,
      alerts        => $alerts,
      tests         => $extra_tests + [$connection_test],
      restart_limit => $restart_limit,
    }
  }
}
