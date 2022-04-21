class ducktape::munin::external::monit(
  Boolean $enabled = true,
  Hash $restart_limit = $ducktape::monit_restart_limit,
) {

  if $enabled {
    #TODO# Add network test
    monit::check::service { $::munin::node::params::service_name:
      pidfile       => $::munin::node::params::pidfile,
      restart_limit => $restart_limit,
    }
  }

}
