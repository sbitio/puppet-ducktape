class ducktape::munin::node (
  Boolean $enabled = true,
  Boolean $manage_repo = true,
  String $repo_ensure = 'latest',
  String $repo_source = 'https://github.com/munin-monitoring/contrib.git',
  String $repo_provider = 'git',
  String $repo_revision = 'master',
  Stdlib::Absolutepath $contrib_plugins_path = '/opt/munin-monitoring',
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
