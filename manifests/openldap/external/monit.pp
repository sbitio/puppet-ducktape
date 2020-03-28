class ducktape::openldap::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    #TODO# Add support for RedHat family.
    $pidfile = $::osfamily ? {
      'Debian' => '/var/run/slapd/slapd.pid',
    }

    $connection_test = {
      type     => 'connection',
      protocol => 'ldap3',
      port     => 389,
      action   => 'restart',
    }
    monit::check::service { $::openldap::server::service:
      pidfile => $pidfile,
      init_system => 'sysv',
      tests => [$connection_test, ],
    }
  }

}

