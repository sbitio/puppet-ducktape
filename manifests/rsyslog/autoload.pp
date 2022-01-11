class ducktape::rsyslog::autoload (
  Boolean $snippet = true,
) {

  if $snippet {
    create_resources('rsyslog::snippet', $ducktape::rsyslog::snippets, $ducktape::rsyslog::snippet_defaults)
  }

}
