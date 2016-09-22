class ducktape::openldap::external::monit(
  $enabled        = true,
) {

  validate_bool($enabled)

  if $enabled {
    #TODO# Add support for RedHat family.
    $pidfile = $::osfamily ? {
      'Debian' => '/var/run/slapd/slapd.pid',
    }
    $init_system = $::lsbdistcodename ? {
      'jessie' => 'sysv',
    }
    monit::check::service { $::openldap::server::service:
      pidfile => $pidfile,
      init_system => $init_system,
    }
  }

}

