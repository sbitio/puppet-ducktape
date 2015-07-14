class ducktape::varnish::external::apache_log_formats_override (
  $enabled  = true,
  $priority = '011',
) {
  if $enabled {
    $vhost_combined = 'LogFormat "%v:%p %{X-Forwarded-For}i %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" vhost_combined'
    $combined       = 'LogFormat "%{X-Forwarded-For}i %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined'
    $common         = 'LogFormat "%{X-Forwarded-For}i %l %u %t \"%r\" %>s %O" common'

    ::ducktape::apache::conf { 'varnish-log-formats-override' :
      priority   => $priority,
      directives => [
        $vhost_combined,
        $combined,
        $common,
      ],
    }
  }
}
