class ducktape::vcsrepo (
  Boolean $enabled,
  Hash $repo_defaults,
  Hash $repos,
) {

  if $enabled {
    require ::ducktape::vcsrepo::autoload
  }

}
