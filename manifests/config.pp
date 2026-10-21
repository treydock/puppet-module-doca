# @api private
class doca::config {
  assert_private()

  if $doca::manage_config {
    $_shellvar_defaults = {
      ensure  => present,
      target  => $doca::openib_config_path,
      notify  => $doca::openib_shellvar_notify,
    }

    create_resources('shellvar', $doca::openib_shellvars, $_shellvar_defaults)
  }
}
