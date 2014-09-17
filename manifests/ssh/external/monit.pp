class ducktape::ssh::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $pidfile = $::osfamily ? {
      /(RedHat|Debian)/ => '/var/run/sshd.pid',
    }

    $test = {
      type     => connection,
      port     => 22,
      protocol => ssh,
    }
    monit::check::service { $::ssh::params::service_name:
      pidfile => $pidfile,
      tests   => [$test, ],
    }
  }

}

