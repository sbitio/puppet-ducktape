class ducktape::firewall::autoload (
  $load_rules = true,
  $load_chains = true,
  $load_rules_multi = true,
) {

  validate_bool($load_rules)
  validate_bool($load_chains)

  if $load_rules {
    $rule_defaults = hiera('ducktape::firewall::rule::defaults', {})
    $rules = hiera_hash('ducktape::firewall::rules', {})
    create_resources('firewall', $rules, $rule_defaults)
  }
  if $load_chains {
    $chain_defaults = hiera('ducktape::firewall::chain::defaults', {})
    $chains = hiera_hash('ducktape::firewall::chains', {})
    create_resources('firewallchain', $chains, $chain_defaults)
  }
  if defined('::firewall_multi') and defined(Class['::firewall_multi']) {
    if $load_rules_multi {
      $rule_defaults = hiera('ducktape::firewall::rule::defaults', {})
      $rules_multi = hiera_hash('ducktape::firewall::rules_multi', {})
      create_resources('firewall_multi', $rules_multi, $rule_defaults)
    }
  }

}

