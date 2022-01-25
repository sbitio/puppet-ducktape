class ducktape::redis::external::munin_node_plugin(
  Boolean $enabled,
  Hash $instance_defaults = {
      bind => $::redis::bind,
      port => $::redis::port,
  },
  Hash $instances = $::redis::instances,
) {

  if $enabled and $ducktape::munin::node::enabled and $ducktape::munin::node::manage_repo {
    # Dependencies.
    case $::osfamily {
      debian : {
        $required_packages = [
          'libredis-perl',
          'libswitch-perl',
        ]
      }
      redhat : {
        $required_packages = []
      }
      default: {
        fail("Unsupported platform: ${::osfamily}")
      }
    }
    ensure_resource('munin::node::plugin::required_package', $required_packages)

    # Declare a instance of the munin plugin for the redis default installation and each
    # redis instance declared via ducktape.
    if $::redis::default_install {
      ducktape::redis::external::munin_node_plugin::instance {'default':
        * => $instance_defaults,
      }
    }
    if $instances {
      $instances.each |$name, $instance| {
        $_instance = merge($instance_defaults, $instance)
        ducktape::redis::external::munin_node_plugin::instance {$name:
          bind => $_instance['bind'],
          port => $_instance['port'],
        }
      }
    }
  }
}

define ducktape::redis::external::munin_node_plugin::instance($bind, $port) {
  $ip = $bind ? {
    '0.0.0.0' => '127.0.0.1',
    default   => $bind,
  }
  $prefix = regsubst($name, '[^0-9a-z]', '_', 'IG')

  @munin::node::plugin {"${prefix}_redis_" :
    target => "${::ducktape::munin::node::contrib_plugins_path}/plugins/redis/redis_",
    sufixes => [
      'connected_clients',
      'key_ratio',
      'keys_per_sec',
      'per_sec',
      'used_keys',
      'used_memory',
    ],
    config  => [
      "env.host $ip",
      "env.port $port",
      "env.title_prefix Redis ($ip:$port)",
    ],
  }
  @munin::node::plugin {"${prefix}_redis-speed" :
    target => "${::ducktape::munin::node::contrib_plugins_path}/plugins/redis/redis-speed",
    config => [
      "env.host $ip",
      "env.port $port",
    ],
  }
}
