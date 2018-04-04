class ducktape::redis::external::munin_node_plugin(
  $enabled = true,
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
    $default_instance = {
      bind => $::redis::bind,
      port => $::redis::port,
    }
    if $::redis::default_install {
      ducktape::redis::external::munin_node_plugin::instance {'default':
        * => $default_instance,
      }
    }
    $::ducktape::redis::instances.each |$name, $instance| {
      $_instance = merge(merge($default_instance, $instance_defaults), $instance)
      ducktape::redis::external::munin_node_plugin::instance {$name:
        * => $_instance,
      }
    }
  }
}

define ducktape::redis::external::munin_node_plugin::instance($bind, $port) {
  $ip = $bind ? {
    '0.0.0.0' => '127.0.0.1',
    default   => $bind,
  }
  $prefix = regsubst("${ip}_${port}", '[^0-9]', '_', 'IG')

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
