# @api private
class doca::service {
  assert_private()

  if $doca::manage_service {
    service { 'openibd':
      ensure => $doca::openibd_service_ensure,
      enable => $doca::openibd_service_enable,
      name   => $doca::openibd_service_name,
    }
  }
}
