class ducktape::corosync (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    corosync::service { 'pacemaker':
      version => 1,
    }
    service { 'pacemaker':
      enable  => true,
      ensure  => running,
      require => Package['pacemaker'],
    }

    anchor { 'corosync::begin': }
    -> Service['corosync']
    -> Service['pacemaker']
    -> anchor { 'corosync::end': }
  }

}

