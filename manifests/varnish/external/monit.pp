class ducktape::varnish::external::monit (
  Boolean $enabled = true,
  String  $action  = 'restart',
  Hash $conn_tolerance = { cycles => 1 },
  String $varnish_host = 'health.varnish',
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {
  if $enabled {
    $pidfile = $facts['os']['family'] ? {
      'Debian' => $facts['os']['distro']['codename'] ? {
        'wheezy' => '/var/run/varnishd.pid',
        default  => '/var/run/varnish.pid',
      },
      default  => '/var/run/varnish.pid',
    }

    # Declare service check.
    $connection_test = {
      type     => 'connection',
      protocol => 'http',
      port     => $varnish::listen_port,
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
      port => $varnish::admin_port,
      action   => $action,
      tolerance => $conn_tolerance,
    }
    monit::check::service { 'varnish':
      pidfile       => $pidfile,
      binary        => '/usr/sbin/varnishd',
      tests         => [$connection_test, $adm_test],
      restart_limit => $restart_limit,
    }
  }
}
