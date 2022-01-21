class ducktape::nfs::client (
  Boolean $enabled = true,
) {

  if $enabled {
    include ducktape::nfs::client::autoload

    # External configs.
    #if defined('::monit') and defined(Class['::monit']) {
    #  include ::ducktape::nfs::client::external::monit
    #}
  }

}
