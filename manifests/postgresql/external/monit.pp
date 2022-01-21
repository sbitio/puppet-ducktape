class ducktape::postgresql::external::monit(
  Boolean $enabled = true,
) {

  if $enabled {
    #TODO# Add network test
    monit::check::service { 'postgresql':
    }
  }

}
