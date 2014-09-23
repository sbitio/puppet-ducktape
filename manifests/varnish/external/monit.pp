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
    $adm_test = {
      type => connection,
      port => $::varnish::varnish_admin_listen_port,
    }
    monit::check::service { 'varnish':
      pidfile => $pidfile,
      binary  => '/usr/sbin/varnishd',
      tests   => [$connection_test, ],
      #TODO# if 5 restarts within 5 cycles then timeout
    }
  }

}

