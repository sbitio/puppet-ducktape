class ducktape::postgresql::external::monit(
  Boolean $enabled,
) {

  if $enabled {
    #TODO# Add network test
    monit::check::service { 'postgresql':
    }
  }

}
