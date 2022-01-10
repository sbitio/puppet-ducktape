class ducktape::openldap::server::external::monit(
  Boolean $enabled = true,
  String  $action  = 'restart',
  Hash $conn_tolerance = { cycles => 1 },
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
      action   => $action,
      tolerance => $conn_tolerance,
    }
    monit::check::service { $::openldap::server::service:
      pidfile => $pidfile,
      init_system => 'sysv',
      tests => [$connection_test, ],
    }
  }

}
