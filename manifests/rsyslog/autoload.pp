class ducktape::rsyslog::autoload (
  Boolean $snippet           = true,
  Hash    $snippet_defaults  = {},
  Hash    $snippets          = {},
) {

  if $snippet {
    create_resources('rsyslog::snippet', $snippets, $snippet_defaults)
  }

}

