class ducktape::mysql::client inherits ducktape::mysql {
  if $enabled {
    anchor { 'ducktape::mysql::client::begin': } ->
      Class['::ducktape::mysql::flavour'] ->
      Class['::mysql::client'] ->
    anchor { 'ducktape::mysql::client::end': }
  }
}

