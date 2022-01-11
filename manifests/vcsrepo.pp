class ducktape::vcsrepo (
  Boolean $enabled = true,
  Hash $repo_defaults = {},
  Hash $repos = {},
) {

  if $enabled {
    require ::ducktape::vcsrepo::autoload
  }

}
