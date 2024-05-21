class ducktape::firewall::autoload (
  Boolean $load_rules = true,
  Boolean $load_chains = true,
) {

  if $load_rules {
    if defined('::firewall_multi') and defined(Resource['::firewall_multi']) {
      create_resources('firewall_multi', $ducktape::firewall::rules, $ducktape::firewall::rule_defaults)
    }
    else {
      create_resources('firewall', $ducktape::firewall::rules, $ducktape::firewall::rule_defaults)
    }
  }
  if $load_chains {
    $ducktape::firewall::chains.each |String $name, Variant[Hash,String] $params| {
      if $params != '' {
        firewallchain { $name:
          * => deep_merge($ducktape::firewall::chain_defaults, $params),
        }
      }
    }
  }

}
