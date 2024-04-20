define ducktape::redis::external::munin_node_plugin::instance (
  Stdlib::IP::Address $bind,
  Integer $port
) {
  $ip = $bind ? {
    '0.0.0.0' => '127.0.0.1',
    default   => $bind,
  }
  $prefix = regsubst($name, '[^0-9a-z]', '_', 'IG')

  @munin::node::plugin { "${prefix}_redis_" :
    target  => "${ducktape::munin::node::contrib_plugins_path}/plugins/redis/redis_",
    sufixes => [
      'connected_clients',
      'key_ratio',
      'keys_per_sec',
      'per_sec',
      'used_keys',
      'used_memory',
    ],
    config  => [
      "env.host ${ip}",
      "env.port ${port}",
      "env.title_prefix Redis (${ip}:${port})",
    ],
  }
  @munin::node::plugin { "${prefix}_redis-speed" :
    target => "${ducktape::munin::node::contrib_plugins_path}/plugins/redis/redis-speed",
    config => [
      "env.host ${ip}",
      "env.port ${port}",
    ],
  }
}
