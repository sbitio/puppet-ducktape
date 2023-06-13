class ducktape::ssh::external::monit(
  Boolean $enabled = true,
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {

  if $enabled {
    $pidfile = $::osfamily ? {
      /(RedHat|Debian)/ => '/var/run/sshd.pid',
    }

    $test = {
      type     => connection,
      port     => 22,
      protocol => ssh,
    }
    monit::check::service { $::ssh::server::service_name:
      pidfile       => $pidfile,
      binary        => $::osfamily ? {
        'Debian' => '/usr/sbin/sshd',
        default  => undef,
      },
      tests         => [$test, ],
      restart_limit => $restart_limit,
    }
  }

}
