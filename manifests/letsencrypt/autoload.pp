class ducktape::letsencrypt::autoload (
  $load_certonlys = true,
  $load_backends  = true,
) {

  validate_bool($load_certonlys)

  if $load_certonlys {
    #TODO# ensure that each key matchs its first domain

    $letsencrypt_certonly_defaults = hiera('ducktape::letsencrypt::certonly::defaults', {})
    create_resources('letsencrypt::certonly', hiera_hash('ducktape::letsencrypt::certonlys', {}), $letsencrypt_certonly_defaults)
  }

}

