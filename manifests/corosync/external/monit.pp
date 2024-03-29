class ducktape::corosync::external::monit(
  Boolean $enabled = true,
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {

  if $enabled {
    #TODO# Add network test
    $pidfile_corosync = $::osfamily ? {
      /(RedHat|Debian)/ => '/var/run/corosync.pid',
    }
    monit::check::service { 'corosync':
      pidfile  => $pidfile_corosync,
    }

    $matching_pacemaker = $::osfamily ? {
      'Debian' => (versioncmp($::operatingsystemrelease, '8') >= 0) ? {
        true  =>  '/usr/sbin/pacemakerd',
        false => undef,
      },
      default => undef,
    }
    $pidfile_pacemaker = $::osfamily ? {
      'Debian' => (versioncmp($::operatingsystemrelease, '8') >= 0) ? {
        true  => undef,
        false => '/var/run/pacemakerd.pid',
      },
      'RedHat' => '/var/run/pacemakerd.pid',
    }
    monit::check::service { 'pacemaker':
      binary        => '/usr/sbin/pacemakerd',
      matching      => $matching_pacemaker,
      pidfile       => $pidfile_pacemaker,
      restart_limit => $restart_limit,
    }
  }

}
