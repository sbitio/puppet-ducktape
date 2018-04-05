class ducktape::redis::external::munin_node_plugin(
  $enabled = true,
) {
  if $enabled and $ducktape::munin::node::enabled and $ducktape::munin::node::manage_repo {
    @munin::node::plugin { 'nutcracker_requests' :
      target => "${::ducktape::munin::node::contrib_plugins_path}/plugins/twemproxy/nutcracker_requests_",
    }
}
