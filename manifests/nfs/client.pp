class ducktape::nfs::client (
  Boolean $enabled,
  Hash $mount_defaults,
  Hash $mounts,
) {

  if $enabled {
    include ducktape::nfs::client::autoload

    # External configs.
    #if defined('::monit') and defined(Class['::monit']) {
    #  include ::ducktape::nfs::client::external::monit
    #}
  }

}
