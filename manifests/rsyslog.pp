class ducktape::rsyslog (
  Boolean $enabled = true,
  Hash    $snippet_defaults  = {},
  Hash    $snippets          = {},
) {

  if $enabled {

    include ducktape::rsyslog::autoload

    # External configs.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::rsyslog::external::monit
    }
  }

}
