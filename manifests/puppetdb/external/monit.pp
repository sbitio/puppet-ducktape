class ducktape::puppetdb::external::monit(
  Boolean $enabled = true,
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {

  if $enabled {
    $pidfile = $::osfamily ? {
      'RedHat' => '/var/run/puppetdb/puppetdb',
      'Debian' => '/run/puppetlabs/puppetdb/puppetdb.pid',
    }

    monit::check::service { $::puppetdb::server::puppetdb_service:
      pidfile       => $pidfile,
      binary        => '/opt/puppetlabs/bin/puppetdb',
      restart_limit => $restart_limit,
    }
  }

}
