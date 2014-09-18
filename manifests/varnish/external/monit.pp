class ducktape::varnish::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $pidfile = $::osfamily ? {
      'RedHat' => '/var/run/varnish.pid',
      'Debian' => '/var/run/varnishd.pid',
    }
    # Declare service check.
    $connection_test = {
      type     => connection,
      protocol => http,
      port     => $::varnish::varnish_listen_port,
      protocol_test => {
        request    => '/',
        hostheader => 'health.varnish',
      },
    }
    monit::check::service { 'varnish':
      pidfile       => $pidfile,
      tests         => [$connection_test, ],
      #TODO# if 5 restarts within 5 cycles then timeout
    }
  }

}

