class ducktape::munin::node (
  $enabled = true,
  $manage_repo = true,
  $contrib_plugins_path = '/opt/munin-monitoring',
) {

  validate_bool($enabled)

  if $enabled {
    if $manage_repo {
      vcsrepo { $contrib_plugins_path :
        ensure   => 'present',
        provider => 'git',
        source   => 'https://github.com/munin-monitoring/contrib.git',
        revision => 'master',
      }
    }

    # External checks.
    if defined('::monit') and defined(Class['::monit']) {
      include ::ducktape::munin::external::monit
    }
  }

}

