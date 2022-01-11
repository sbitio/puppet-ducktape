class ducktape::nfs::server (
  Boolean $enabled = true,
) {

  if $enabled {
    include ducktape::nfs::server::autoload

    # External configs.
    #if defined('::monit') and defined(Class['::monit']) {
    #  include ::ducktape::nfs::server::external::monit
    #}
  }

}
