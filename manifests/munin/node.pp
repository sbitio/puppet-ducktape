class ducktape::munin::node (
  Boolean $enabled ,
  Boolean $manage_repo ,
  String $repo_ensure ,
  String $repo_source ,
  String $repo_provider ,
  String $repo_revision ,
  Stdlib::Absolutepath $contrib_plugins_path ,
) {

  if $enabled {
    if $manage_repo {
      vcsrepo { $contrib_plugins_path :
        ensure   => $repo_ensure,
        provider => $repo_provider,
        source   => $repo_source,
        revision => $repo_revision,
      }
    }

    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::munin::external::monit
    }
  }

}
