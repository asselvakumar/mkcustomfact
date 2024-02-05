# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include mkcustomfact::internet_explorer
class mkcustomfact::internet_explorer (
  Boolean $esc_enabled_admin = false,
  Boolean $esc_enabled_user = false,
){
  dsc_ieenhancedsecurityconfiguration { 'esc_enabled_admin' :
    dsc_enabled     => $esc_enabled_admin,
    dsc_role        => 'Administrators',
    validation_mode => 'resource',
  }
  dsc_ieenhancedsecurityconfiguration { 'esc_enabled_user' :
    dsc_enabled     => $esc_enabled_user,
    dsc_role        => 'Users',
    validation_mode => 'resource',
  }
}
