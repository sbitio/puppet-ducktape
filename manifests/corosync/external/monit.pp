class ducktape::corosync::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $pidfile_corosync = $::osfamily ? {
      /(RedHat|Debian)/ => '/var/run/corosync.pid',
    }
    monit::check::service { 'corosync':
      pidfile  => $pidfile_corosync,
    }

    $pidfile_pacemaker = $::osfamily ? {
      'RedHat' => '/var/run/pacemakerd.pid',
      'Debian' => '/var/run/pacemakerd.pid', #TODO# Untested
    }
    monit::check::service { 'pacemaker':
      pidfile  => $pidfile_pacemaker,
    }
  }

}

