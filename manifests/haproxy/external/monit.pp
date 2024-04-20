class ducktape::haproxy::external::monit (
  Boolean $enabled = true,
  Array[Hash] $tests = [],
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {
  if $enabled {
    $init_system = $facts['os']['name'] ? {
      'Ubuntu' => $facts['os']['distro']['release']['major'] ? {
        /(12\.|14\.)/ => 'sysv',
        default       => undef,
      },
      default  => undef,
    }

    monit::check::service { 'haproxy':
      init_system   => $init_system,
      pidfile       => $haproxy::params::global_options['pidfile'],
      tests         => $tests,
      restart_limit => $restart_limit,
    }
  }
}
