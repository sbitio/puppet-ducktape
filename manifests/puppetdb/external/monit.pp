class ducktape::puppetdb::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $pidfile = $::osfamily ? {
      'RedHat' => '/var/run/puppetdb/puppetdb',
      'Debian' => '/var/run/puppetdb.pid',
    }

    monit::check::service { $::puppetdb::server::puppetdb_service:
      pidfile => $pidfile,
    }
  }

}

