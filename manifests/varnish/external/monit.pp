class ducktape::varnish::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    # Declare service check.
    $connection_test = {
      type     => connection,
      protocol => http,
      port     => $::varnish::listen_port,
      protocol_test => {
        request    => '/',
        hostheader => 'health.varnish',
      },
    }
    #TODO# Provide a test for admin interface
    $adm_test = {
      type => connection,
      protocol => http,
      port => $::varnish::varnish_admin_listen,
      port => $::varnish::varnish_admin_port,
    }
    monit::check::service { 'varnish':
      pidfile     => '/var/run/varnish.pid'
      binary      => '/usr/sbin/varnishd',
      tests       => [$connection_test, $adm_test],
      #TODO# if 5 restarts within 5 cycles then timeout
    }
  }

}

