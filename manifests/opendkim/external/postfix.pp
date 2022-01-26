class ducktape::opendkim::external::postfix(
  Boolean $enabled,
) {

  if $enabled {
    $socket_postfix_def = "inet:127.0.0.1:${$ducktape::opendkim::port}"
    postfix::config {
      "smtpd_milters"         : value => $socket_postfix_def;
      "non_smtpd_milters"     : value => $socket_postfix_def;
      "milter_default_action" : value => 'accept';
    }
  }

}
