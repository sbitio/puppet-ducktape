class ducktape::puppetdb::external::monit(
  Boolean $enabled,
) {

  if $enabled {
    $pidfile = $::osfamily ? {
      'RedHat' => '/var/run/puppetdb/puppetdb',
      'Debian' => '/run/puppetlabs/puppetdb/puppetdb.pid',
    }

    monit::check::service { $::puppetdb::server::puppetdb_service:
      pidfile => $pidfile,
      binary  => '/opt/puppetlabs/bin/puppetdb',
    }
  }

}
