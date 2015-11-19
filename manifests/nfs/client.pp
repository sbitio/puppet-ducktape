class ducktape::nfs::client (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ducktape::nfs::client::autoload

    # External configs.
    #if defined('::monit') and defined(Class['::monit']) {
    #  include ::ducktape::nfs::client::external::monit
    #}
  }

}

