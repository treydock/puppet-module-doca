# @api private
class doca::install {
  assert_private()

  if $doca::manage_packages {
    package { $doca::package_name:
      ensure => $doca::package_ensure,
    }

    if ! empty($doca::extra_packages) {
      stdlib::ensure_packages($doca::extra_packages)
    }
  }
}
