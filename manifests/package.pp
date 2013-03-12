# == Class: jbossas::package
#
# This class exists to coordinate all software package management related
# actions, functionality and logical units in a central place.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'jbossas::package': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Luca Gioppo <mailto:gioppoluca@libero.it>
#
class jbossas::package {

  #### Package management

  # set params: in operation
  if $jbossas::ensure == 'present' {

    $package_ensure = $jbossas::autoupgrade ? {
      true  => 'latest',
      false => 'present',
    }

  # set params: removal
  } else {
    $package_ensure = 'purged'
  }

  # action
  package { $jbossas::params::package:
    ensure => $package_ensure,
  }

}
