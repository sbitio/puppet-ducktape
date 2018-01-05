class ducktape::varnish::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    $pidfile = $::osfamily ? {
      'Debian' => $::lsbdistcodename ? {
        'wheezy' => '/var/run/varnishd.pid',
        default  => '/var/run/varnish.pid',
      },
      default  => '/var/run/varnish.pid',
    }

    # Declare service check.
    $connection_test = {
      type     => 'connection',
      protocol => 'http',
      port     => $::varnish::listen_port,
      protocol_test => {
        request    => '/',
        hostheader => 'health.varnish',
      },
    }
    #TODO# Provide a test for admin interface
    $adm_test = {
      type => 'connection',
      protocol => 'http',
      port => $::varnish::admin_port,
    }
    monit::check::service { 'varnish':
      pidfile     => $pidfile,
      binary      => '/usr/sbin/varnishd',
      tests       => [$connection_test, $adm_test],
      #TODO# if 5 restarts within 5 cycles then timeout
    }
  }

}

