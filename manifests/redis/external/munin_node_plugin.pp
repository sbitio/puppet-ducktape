class ducktape::redis::external::munin_node_plugin (
  Boolean $enabled = true,
  Hash $instance_defaults = {
    bind => $redis::bind,
    port => $redis::port,
  },
  Hash $instances = $redis::instances,
) {
  if $enabled and $ducktape::munin::node::enabled and $ducktape::munin::node::manage_repo {
    # Dependencies.
    case $facts['os']['family'] {
      'debian': {
        $required_packages = [
          'libredis-perl',
          'libswitch-perl',
        ]
      }
      'redhat': {
        $required_packages = []
      }
      default: {
        fail("Unsupported platform: ${facts['os']['family']}")
      }
    }
    ensure_resource('munin::node::plugin::required_package', $required_packages)

    # Declare a instance of the munin plugin for the redis default installation and each
    # redis instance declared via ducktape.
    if $redis::default_install {
      ducktape::redis::external::munin_node_plugin::instance { 'default':
        * => $instance_defaults,
      }
    }
    if $instances {
      $instances.each |$name, $instance| {
        $_instance = merge($instance_defaults, $instance)
        ducktape::redis::external::munin_node_plugin::instance { $name:
          bind => $_instance['bind'],
          port => $_instance['port'],
        }
      }
    }
  }
}
