class ducktape::dns::autoload (
  Boolean $server_options          = true,
  Hash    $server_options_defaults = {},
  Hash    $server_optionss         = {},
  Boolean $zone                    = true,
  Hash    $zone_defaults           = {},
  Hash    $zones                   = {},
  Boolean $record_a                = true,
  Hash    $record_a_defaults       = {},
  Hash    $record_as               = {},
  Boolean $record_cname            = true,
  Hash    $record_cname_defaults   = {},
  Hash    $record_cnames           = {},
  Boolean $record                  = true,
  Hash    $record_defaults         = {},
  Hash    $records                 = {},
) {

  if $server_options {
    create_resources('dns::server::options', $server_optionss, $server_options_defaults)
  }

  if $zone {
    create_resources('dns::zone', $zones, $zone_defaults)
  }

  if $record_a {
    create_resources('dns::record::a', $record_as, $record_a_defaults)
  }
  if $record_cname {
    create_resources('dns::record::cname', $record_cnames, $record_cname_defaults)
  }
  if $record {
    create_resources('dns::record', $records, $record_defaults)
  }

}
