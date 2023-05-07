class ducktape::postgresql::external::munin_node_plugin(
  Boolean $enabled = true,
  Enum['present', 'absent'] $ensure = 'present',
  Array[String] $plugins = [
    'pg__connections',
    'postgres_locks',
    'postgresql_active_backends',
    'postgresql_active_backends_by_database',
    'postgresql_active_locks',
    'postgresql_database_ratio',
    'postgresql_database_size',
    'postgresql_tablespace_size',
    'postgresql_transactions',
  ],
  Array[String] $plugins_for_db = [
    'postgres_block_read_',
    'postgres_queries2_',
    'postgres_queries3_',
    'postgres_size_detail_',
    'postgres_space_',
    'postgres_tuplesratio_',
  ],
  Array[String] $databases = [],
) {

  $required_packages = [
    'libdbd-pg-perl',
  ]
  ensure_resource('munin::node::plugin::required_package', $required_packages)

  $plugins.each |$plugin| {
    @munin::node::plugin { $plugin:
      target => "${::ducktape::munin::node::contrib_plugins_path}/plugins/postgresql/${plugin}",
      config => [
        'user postgres',
        'env.dbuser postgres',
        "env.dbpass $postgresql::server::postgres_password",
      ],
      require => [
        Class['::postgresql::server'],
        Package[$required_packages],
      ],
    }
  }

  $plugins_for_db.each |$plugin| {
    @munin::node::plugin { $plugin:
      target => "${::ducktape::munin::node::contrib_plugins_path}/plugins/postgresql/${plugin}",
      sufixes => $databases,
      config => [
        'user postgres',
        'env.dbuser postgres',
        "env.dbpass $postgresql::server::postgres_password",
      ],
      require => [
        Class['::postgresql::server'],
        Package[$required_packages],
      ],
    }
  }
}
