class ducktape::varnish (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ::ducktape::varnish::vcl
    include ::ducktape::varnish::secret

    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::varnish::external::monit
    }
    if defined('::apache') and defined(Class['::apache']) {
      include ::ducktape::varnish::external::apache_log_formats_override
    }
  }

}

