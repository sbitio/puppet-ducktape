# See https://gallery.munin-monitoring.org/plugins/munin-contrib/docker_/
class ducktape::docker::external::munin_node_plugin (
  Boolean $enabled = true,
  String $exclude_container_name_regexp = '^$',
) {
  if $enabled and $ducktape::munin::node::enabled and $ducktape::munin::node::manage_repo {
    # Dependencies.
    case $facts['os']['family'] {
      'debian': {
        $required_packages = [
          'python3-docker',
        ]
      }
      default: {
        fail("Unsupported platform: ${facts['os']['family']}")
      }
    }
    ensure_resource('munin::node::plugin::required_package', $required_packages)

    @munin::node::plugin { 'docker_':
      target  => "${ducktape::munin::node::contrib_plugins_path}/plugins/docker/docker_",
      sufixes => [
        'containers',
        'images',
        'status',
        'volumes',
        'cpu',
        'memory',
        'network',
      ],
      config  => [
        'group docker',
        'env.DOCKER_HOST unix://run/docker.sock',
        "env.EXCLUDE_CONTAINER_NAME ${exclude_container_name_regexp}",
      ],
    }
  }
}
