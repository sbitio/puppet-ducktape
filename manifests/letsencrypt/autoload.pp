class ducktape::letsencrypt::autoload (
  $load_certonlys = true,
) {

  validate_bool($load_certonlys)

  if $load_certonlys {
    #TODO# ensure that each key matchs its first domain

    $defaults = hiera('ducktape::letsencrypt::certonly::defaults', {})
    $certs = hiera_hash('ducktape::letsencrypt::certonlys', {})
    create_resources('letsencrypt::certonly', $certs, $defaults)

    # External checks.
    if $::ducktape::letsencrypt::icinga2_checks_enabled {
      if defined('::icinga2') and defined(Class['::icinga2']) {

        ## Añadir a check.pp la lógica para fusionar los icinga2_check_params con los parametros domain specific
        ## Filtrar el merge de abajo para dejar sólo domains.
        $_certs = merge($defaults, $certs)
        notify{"CERTS TO CHECK: $_certs":}
        $x = $_certs.filter |$items| { $items[1].filter |$child| {$child[0] == 'domains' } }
        notify{"FILTERED CERTS TO CHECK: $x":}

        create_resources('letsencrypt::external::icinga2::check', $x, $icinga2_check_params)
      }
    }
  }

}

