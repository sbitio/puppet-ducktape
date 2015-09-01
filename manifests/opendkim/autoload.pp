class ducktape::opendkim::autoload (
  $load_domains  = true,
  $load_trusteds = true,
) {

  validate_bool($load_domains)
  validate_bool($load_trusteds)

  if $load_domains {
    $domain_defaults = hiera('ducktape::opendkim::domain::defaults', {})
    create_resources('::opendkim::domain', hiera_hash('ducktape::opendkim::domains', {}), $domain_defaults)
  }

  if $load_trusteds {
    $trusted_defaults = hiera('ducktape::opendkim::trusted::defaults', {})
    create_resources('::opendkim::trusted', hiera_hash('ducktape::opendkim::trusteds', {}), $trusted_defaults)
  }

}

