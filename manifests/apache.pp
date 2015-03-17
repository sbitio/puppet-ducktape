class ducktape::apache (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    # Declare configuration snippets.
    $defaults = hiera('ducktape::apache::conf::defaults', {})
    $confs    = hiera_hash('ducktape::apache::confs', {})
    create_resources('::ducktape::apache::conf', $confs, $defaults)

    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::apache::external::monit
    }
    if defined('::munin') and defined(Class['::munin']) {
      include ::ducktape::apache::external::munin::node::plugin
    }
    # Autoincluded classes
    include ::ducktape::apache::more_log_formats
    include ::ducktape::apache::other_vhosts_log
    include ::ducktape::apache::shield_vhost
  }

}

