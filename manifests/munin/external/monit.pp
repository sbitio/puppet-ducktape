class ducktape::munin::external::monit(
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    #TODO# Add network test
    monit::check::service { "$::munin::node::params::service_name":
      pidfile => $::munin::node::params::pidfile,
    }
  }

}

