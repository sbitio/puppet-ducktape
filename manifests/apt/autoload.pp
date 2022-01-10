class ducktape::apt::autoload(
  Boolean $load_keys = true,
  Boolean $load_sources = true,
) {

  if $load_keys {
    create_resources('::apt::key', $ducktape::apt::keys, $ducktape::apt::key_defaults)
  }

  if $load_sources {
    create_resources('::apt::source', $ducktape::apt::sources, $ducktape::apt::source_defaults)
  }

}
