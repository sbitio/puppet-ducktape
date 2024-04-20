class ducktape::vcsrepo::autoload (
  Boolean $autoload = true,
) {
  if $autoload {
    create_resources('vcsrepo', $ducktape::vcsrepo::repos, $ducktape::vcsrepo::repo_defaults)
  }
}
