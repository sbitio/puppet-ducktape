class ducktape::nfs::server (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ducktape::nfs::server::autoload

    # External configs.
    #if defined('::monit') and defined(Class['::monit']) {
    #  include ::ducktape::nfs::server::external::monit
    #}
  }

}

