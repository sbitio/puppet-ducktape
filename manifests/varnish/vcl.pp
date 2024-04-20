#TODO# try to move this to upstream module
class ducktape::varnish::vcl (
  Boolean $enabled = true,
  String $vcl_name = 'puppet',
  Optional[Variant[Array, String]] $vcl_source = undef,
) {
  if $enabled {
    if $vcl_source != undef {
      $ensure = $varnish::varnish_version ? {
        'absent' => 'absent',
        default  => 'present',
      }
      file { "/etc/varnish/${vcl_name}.vcl" :
        ensure  => $ensure,
        source  => $vcl_source,
        require => Class['varnish::install'],
        #TODO This is quite dirty&fragile (accessing internal), but since notifying varnish::service class restarts varnish...
        notify  => Exec['vcl_reload'],
      }
    }
  }
}
