class ducktape::corosync (
  Boolean $enabled = true,
) {

  if $enabled {
    corosync::service { 'pacemaker':
      version => 1,
    }
    if (!$::corosync::manage_pacemaker_service) {
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

    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::corosync::external::monit
    }
  }

}
