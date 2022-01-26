class ducktape::letsencrypt::autoload (
  Boolean $load_certonlys,
  Boolean $load_backends,
) {


  if $load_certonlys {
    #TODO# ensure that each key matchs its first domain

    create_resources('letsencrypt::certonly', $ducktape::letsencrypt::certonlys, $ducktape::letsencrypt::certonly_defaults)
  }

}
