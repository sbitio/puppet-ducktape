class ducktape::ntp::external::monit (
  Boolean $enabled = true,
  String $action  = 'restart',
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {
  if $enabled {
    $pidfile = $facts['os']['family'] ? {
      'Debian' => '/var/run/ntpd.pid',
      'RedHat' => $facts['os']['distro']['release']['major'] ? {
        7       => undef,
        default => '/var/run/ntpd.pid',
      },
    }
    $matching = $facts['os']['family'] ? {
      'Debian' => undef,
      'RedHat' => $facts['os']['distro']['release']['major'] ? {
        7       => '/usr/sbin/ntpd',
        default => undef,
      },
    }
    $init_system = $facts['os']['name'] ? {
      'Ubuntu' => $facts['os']['distro']['release']['major'] ? {
        /(12\.|14\.)/ => 'sysv',
        default       => undef,
      },
      'Debian' => $facts['os']['distro']['codename'] ? {
        'jessie'  => 'sysv',
        'stretch' => 'sysv',
        default   => undef,
      },
      default  => undef,
    }

    $test = {
      type        => 'connection',
      socket_type => 'udp',
      port        => 123,
      action      => $action,
    }
    $binary = $facts['os']['family'] ? {
      'Debian' => '/usr/sbin/ntpd',
      default  => undef,
    }
    monit::check::service { $ntp::service_name:
      init_system   => $init_system,
      pidfile       => $pidfile,
      matching      => $matching,
      binary        => $binary,
      tests         => [$test,],
      restart_limit => $restart_limit,
    }
  }
}
