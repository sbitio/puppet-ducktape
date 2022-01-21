class ducktape::varnish::vcl (
  Boolean $enabled    = true,
  String $vcl_name   = 'puppet',
  $vcl_source = undef,
) {

#TODO# try to move this to upstream module

  if $enabled {
    if $vcl_source != undef {
      #TODO# make a propper vcl_source validation, since it can be an array or a string
      file { "/etc/varnish/${vcl_name}.vcl" :
        ensure  => $::varnish::varnish_version ? {
          absent  => absent,
          default => present,
        },
        source  => $vcl_source,
        require => Class['::varnish::install'],
        #TODO This is quite dirty&fragile (accessing internal), but since notifying varnish::service class restarts varnish...
        notify  => Exec['vcl_reload'],
      }
    }
  }

}
