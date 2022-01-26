class ducktape::twemproxy::external::munin_node_plugin(
  Boolean $enabled,
) {
  if $enabled and $ducktape::munin::node::enabled and $ducktape::munin::node::manage_repo {
    @munin::node::plugin { 'nutcracker_requests' :
      target => "${::ducktape::munin::node::contrib_plugins_path}/plugins/twemproxy/nutcracker_requests_",
    }
  }
}
