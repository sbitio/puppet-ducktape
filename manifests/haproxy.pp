class ducktape::haproxy (
  Boolean $enabled = true,
  Optional[Array[String]] $package_install_options = undef,
  Hash    $backend_defaults   = {},
  Hash    $backends           = {},
  Hash    $frontend_defaults  = {},
  Hash    $frontends          = {},
  Hash    $peers              = {},
  Hash    $userlist_defaults  = {},
  Hash    $userlists          = {},
) {
  if $enabled {
    if ($package_install_options) {
      Package <| title == $haproxy::package_name |> {
        install_options => $package_install_options,
      }
    }

    contain ducktape::haproxy::autoload

    # External configs.
    if defined('munin::node') and defined(Class['munin::node']) {
      contain ducktape::haproxy::external::munin_node_plugin
    }
    if defined('monit') and defined(Class['monit']) {
      contain ducktape::haproxy::external::monit
    }
  }
}
