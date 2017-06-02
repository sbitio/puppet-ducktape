class ducktape::haproxy (
  $enabled = true,
  $package_install_options = undef,
) {

  validate_bool($enabled)

  if $enabled {
    if ($package_install_options) {
      Package <| title == "$::haproxy::package_name" |> {
        install_options => $package_install_options,
      }
    }

    include ducktape::haproxy::autoload

    include ducktape::haproxy::latest

    # External configs.
    if defined('::munin::node') and defined(Class['::munin::node']) {
      include ::ducktape::haproxy::external::munin_node_plugin
    }
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::haproxy::external::monit
    }
    if defined('::rsyslog') and defined(Class['::rsyslog']) {
      include ::ducktape::haproxy::external::rsyslog
    }
  }

}

