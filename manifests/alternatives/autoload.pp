class ducktape::alternatives::autoload (
  Boolean $load_alternatives = true,
) {

  if $load_alternatives {
    create_resources('alternatives', $ducktape::alternatives::alternatives, $ducktape::alternatives::alternative_defaults)
  }

}
