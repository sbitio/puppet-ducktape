define ducktape::mysql::external::munin_node_plugin::kjellm_link (
  Stdlib::Absolutepath $source_dir,
  Stdlib::Absolutepath $perl_lib_dir,
) {
  $src = "${source_dir}/${name}"
  $dst = "${perl_lib_dir}${name}"
  exec { "ducktape-mysql-server-external-munin_node_plugin-kjellm_link-${name}" :
    command => "ln -s ${src} ${dst}",
    unless  => "test $(readlink ${dst}) = ${src}",
  }
}
