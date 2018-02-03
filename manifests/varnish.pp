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
    # Restart varnish if the systemd unit has changed.
    # Note: system::dropin_file is available in systemd >= 1.0.0
    if defined('::systemd') and defined(Class['::systemd']) and defined(Resource['::systemd::dropin_file']) {
      Class['::varnish::install']
      -> Systemd::Dropin_file<| unit == 'varnish.service' |>
      ~> Class['::varnish::service']
    }
  }

}
