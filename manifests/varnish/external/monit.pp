class ducktape::varnish::external::monit(
  Boolean $enabled,
  String  $action,
  Hash $conn_tolerance,
  String $varnish_host,
) {

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
        hostheader => $varnish_host,
      },
      action   => $action,
      tolerance => $conn_tolerance,
    }
    #TODO# Provide a test for admin interface
    $adm_test = {
      type => 'connection',
      port => $::varnish::admin_port,
      action   => $action,
      tolerance => $conn_tolerance,
    }
    monit::check::service { 'varnish':
      pidfile     => $pidfile,
      binary      => '/usr/sbin/varnishd',
      tests       => [$connection_test, $adm_test],
      #TODO# if 5 restarts within 5 cycles then timeout
    }
  }

}
