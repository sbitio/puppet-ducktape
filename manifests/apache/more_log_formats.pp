class ducktape::apache::more_log_formats (
  $enabled  = true,
  $priority = '010',
) {
  if $enabled {
    $vhost_combined = 'LogFormat "%v:%p %h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" vhost_combined'
    ::ducktape::apache::conf { 'more-log-formats' :
      priority   => $priority,
      directives => [
        $vhost_combined,
      ],
    }
  }
}
