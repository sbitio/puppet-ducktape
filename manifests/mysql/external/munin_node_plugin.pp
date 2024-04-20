class ducktape::mysql::external::munin_node_plugin (
  Boolean $enabled            = true,
  Enum['present', 'absent'] $ensure = 'present',
  Boolean $old_plugin         = false,
  # No mysql_innodb and no mysql_isam_space_
  Array[String] $old_plugins        = [
    'mysql_bytes',
    'mysql_queries',
    'mysql_slowqueries',
    'mysql_threads',
  ],
  Boolean $new_plugin         = false,
  Array[String] $new_plugin_sufixes = [
    'bin_relay_log',
    'commands',
    'connections',
    'files_tables',
    'innodb_bpool',
    'innodb_bpool_act',
    'innodb_insert_buf',
    'innodb_io',
    'innodb_io_pend',
    'innodb_log',
    'innodb_rows',
    'innodb_semaphores',
    'innodb_tnx',
    'myisam_indexes',
    'network_traffic',
    'qcache',
    'qcache_mem',
    'replication',
    'select_types',
    'slow',
    'sorts',
    'table_locks',
    'tmp_tables',
  ],
  Boolean $kjellm_plugin      = true,
  Array[String] $kjellm_plugins     = [
    'InnoDB.pm',
    'MyISAM.pm',
    'QueryCache.pm',
    'ReplicationSlave.pm',
    'Standard.pm',
  ],
  Array[String] $kjellm_contribs    = [
    'CacheEfficiency.pm',
  ],
  Stdlib::Absolutepath $kjellm_repo_dst = '/opt/kjellm-munin-mysql'
) {
  if $enabled and defined('munin::node') and defined(Class['munin::node']) {
    $required_packages = $facts['os']['name'] ? {
      'Debian' => $facts['os']['distro']['codename'] ? {
        'jessie'  => 'libdbd-mysql-perl',
        'stretch' => 'libdbd-mysql-perl',
        default   => 'libcache-cache-perl',
      },
      default  => [],
    }

    $all_plugins = concat(['mysql_'], $old_plugins)

    if $old_plugin or $new_plugin {
      @munin::node::plugin::required_package { $required_packages :
        ensure => $ensure,
        #TODO# add stdlib as dependency
        tag    => $all_plugins,
      }
    }
    if $old_plugin {
      @munin::node::plugin { $old_plugins :
        ensure            => $ensure,
        required_packages => $required_packages,
        require           => Package[$required_packages],
      }
    }
    else {
      @munin::node::autoconf::exclusion { $old_plugins : }
    }
    if $new_plugin {
      @munin::node::plugin { 'mysql_' :
        ensure  => $ensure,
        sufixes => $new_plugin_sufixes,
        require => [
          Service[$mysql::params::service_name],
          Package[$required_packages],
        ],
      }
    }
    else {
      @munin::node::autoconf::exclusion { 'mysql_' : }
    }

    if $kjellm_plugin {
      require munin::node::params

      vcsrepo { $kjellm_repo_dst :
        ensure   => $ensure,
        provider => git,
        source   => 'https://github.com/kjellm/munin-mysql',
        revision => 'master',
      }

      # Based on makefile https://github.com/kjellm/munin-mysql/blob/master/Makefile
      $kjellm_ensure = $ensure
      $lib_dir = "${munin::node::params::imported_scripts_dir}/mysql_lib"
      $kjellm_file_ensure = $kjellm_ensure ? {
        'present' => link,
        default   => $ensure
      }
      file { $lib_dir:
        ensure => $kjellm_file_ensure,
        target => "${kjellm_repo_dst}/lib/Munin/MySQL/Graph",
      }
      $contrib_dir = "${munin::node::params::imported_scripts_dir}/mysql_contrib"
      file { $contrib_dir:
        ensure => $kjellm_file_ensure,
        target => "${kjellm_repo_dst}/contrib/Munin/MySQL/Graph",
      }
      $perl_lib_dir = "$(perl '-V:installsitelib' | cut -d \"'\" -f2)/Munin/MySQL/Graph/"
      case $kjellm_ensure {
        default, 'present': {
          exec { 'kjellm-create-perl-lib-dir' :
            command => "mkdir -p ${perl_lib_dir}",
            unless  => "test -d ${perl_lib_dir}",
          }
          ducktape::mysql::external::munin_node_plugin::kjellm_link { $kjellm_plugins :
            source_dir   => $lib_dir,
            perl_lib_dir => $perl_lib_dir,
            require      => Exec['kjellm-create-perl-lib-dir'],
          }
          ducktape::mysql::external::munin_node_plugin::kjellm_link { $kjellm_contribs :
            source_dir   => $contrib_dir,
            perl_lib_dir => $perl_lib_dir,
            require      => Exec['kjellm-create-perl-lib-dir'],
          }
        }
        'absent': {
          exec { 'kjellm-create-perl-lib-dir' :
            command => "rm -rf ${perl_lib_dir}",
            onlyif  => "test -d ${perl_lib_dir}",
          }
        }
      }
      case $facts['os']['family'] {
        'debian': {
          $kjellm_required_packages = ['libmodule-pluggable-perl', 'libcache-cache-perl']
          @munin::node::plugin::required_package { $kjellm_required_packages:
            ensure => $ensure,
            tag    => 'mysql',
          }
        }
        default: {}
      }
      @munin::node::plugin::conf { 'mysql' :
        ensure  => $ensure,
        content => template('ducktape/mysql/external/kjellm_munin_plugin_conf.erb'),
      }
      @munin::node::plugin { 'mysql' :
        ensure  => $ensure,
        target  => "${kjellm_repo_dst}/mysql",
        require => [
          Ducktape::Mysql::External::Munin_node_plugin::Kjellm_link[$kjellm_plugins],
          Ducktape::Mysql::External::Munin_node_plugin::Kjellm_link[$kjellm_contribs],
        ],
      }
    }
  }
}
