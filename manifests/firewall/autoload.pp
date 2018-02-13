class ducktape::firewall::autoload (
  $load_rules = true,
  $load_chains = true,
) {

  validate_bool($load_rules)
  validate_bool($load_chains)

  if $load_rules {
    $rule_defaults = hiera('ducktape::firewall::rule::defaults', {})
    $rules = hiera_hash('ducktape::firewall::rules', {})
    if defined('::firewall_multi') and defined(Resource['::firewall_multi']) {
      create_resources('firewall_multi', $rules, $rule_defaults)
    }
    else {
      create_resources('firewall', $rules, $rule_defaults)
    }
  }
  if $load_chains {
    $chain_defaults = hiera('ducktape::firewall::chain::defaults', {})
    $chains = hiera_hash('ducktape::firewall::chains', {})
    create_resources('firewallchain', $chains, $chain_defaults)
  }

}

