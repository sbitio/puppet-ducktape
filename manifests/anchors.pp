class ducktape::anchors(
  Boolean $enabled = true,
  Hash $anchors,
  Hash $anchor_defaults,
) {

  if $enabled {

    $anchors.each |$anchor_name, $_config| {
      $config = merge($anchor_defaults, $_config)
      $before = $config['before'];
      $after = $config['after'];

      if ($before['type'] == 'class') and ($after['type'] == 'class') {
        anchor{ "${anchor_name}_first": }
        -> Class[$before['title']]
        -> Class[$after['title']]
        -> anchor{ "${anchor_name}_last": }
      }
      elsif ($before['type'] == 'class') and ($after['type'] != 'class') {
        anchor{ "${anchor_name}_first": }
        -> Class[$before['title']]
        -> Resource[$after['type'], $after['title']]
        -> anchor{ "${anchor_name}_last": }
      }
      elsif ($before['type'] != 'class') and ($after['type'] == 'class') {
        anchor{ "${anchor_name}_first": }
        -> Resource[$before['type'], $before['title']]
        -> Class[$after['title']]
        -> anchor{ "${anchor_name}_last": }
      }
      else {
        anchor{ "${anchor_name}_first": }
        -> Resource[$before['type'], $before['title']]
        -> Resource[$after['type'], $after['title']]
        -> anchor{ "${anchor_name}_last": }
      }
    }
  }

}
