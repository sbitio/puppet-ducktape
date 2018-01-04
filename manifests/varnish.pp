class ducktape::varnish (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ::ducktape::varnish::vcl

    if defined('::munin::node') and defined(Class['::munin::node']) {
      include ::ducktape::varnish::external::munin_node_plugin
    }
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::varnish::external::monit
    }
    if defined('::apache') and defined(Class['::apache']) {
      include ::ducktape::varnish::external::apache_log_formats_override
    }
    if defined('::systemd') and defined(Class['::systemd']) {
      Systemd::Dropin_file<| unit == 'varnish.service' |> ~> Class['::varnish::service']
    }
  }

}
