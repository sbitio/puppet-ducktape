class ducktape::apache::other_vhosts_log (
  $enabled  = true,
  $priority = '012',
  $format   = 'vhost_combined',
) {
  if $enabled {
    $directive = "CustomLog ${::apache::params::logroot}/other_vhosts_access.log ${format} env=!dontlog"
    ::ducktape::apache::conf { 'other-vhosts-access-log' :
      priority   => $priority,
      directives => [
        "# Define an access log for VirtualHosts that don't define their own logfile",
        $directive,
      ],
    }
  }
}
