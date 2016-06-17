class ducktape::topbeat::external::monit(
  $enabled        = true,
) {

  validate_bool($enabled)
  #TODO# Add more validations

  if $enabled {
    $pidfile = '/var/run/topbeat.pid'
    monit::check::service { 'topbeat':
      pidfile => $pidfile,
      binary  => '/usr/bin/topbeat-god',
    }
  }

}

