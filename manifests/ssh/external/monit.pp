class ducktape::ssh::external::monit (
  Boolean $enabled = true,
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {
  if $enabled {
    $pidfile = $facts['os']['family'] ? {
      /(RedHat|Debian)/ => '/var/run/sshd.pid',
    }

    $service_name = $ssh::server::service_name ? {
      undef   => $ssh::params::service_name,
      default => $ssh::server::service_name
    }

    $test = {
      type     => connection,
      port     => 22,
      protocol => ssh,
    }
    $binary = $facts['os']['family'] ? {
      'Debian' => '/usr/sbin/sshd',
      default  => undef,
    }
    monit::check::service { $service_name:
      pidfile       => $pidfile,
      binary        => $binary,
      tests         => [$test,],
      restart_limit => $restart_limit,
    }
  }
}
