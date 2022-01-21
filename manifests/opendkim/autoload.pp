class ducktape::opendkim::autoload (
  Boolean $load_domains  = true,
  Boolean $load_trusteds = true,
) {

  if $load_domains {
    create_resources('::opendkim::domain', $ducktape::opendkim::domains, $ducktape::opendkim::domain_defaults)
  }

  if $load_trusteds {
    create_resources('::opendkim::trusted', $ducktape::opendkim::trusteds, $ducktape::opendkim::trusted_defaults)
  }

}
