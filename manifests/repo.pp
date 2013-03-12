# == Class: jbossas::repo
#
# FIXME/TODO Please check if you want to remove this class because it may be
#            unnecessary for your module. Don't forget to update the class
#            declarations and relationships at init.pp afterwards (the relevant
#            parts are marked with "FIXME/TODO" comments).
#
# This class exists to coordinate all repository related actions, functionality
# and logical units in a central place.
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
#   class { 'jbossas::repo': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Luca Gioppo <mailto:gioppoluca@libero.it>
#
class jbossas::repo {

  #### Repository management

  # nothing right now

  # Helpful snippets:
  #
  # YUM repository. See 'yumrepo' doc at http://j.mp/gtCgFw for information.
  # $repo_enabled = $jbossas::ensure ? {
  #   # Removal of the repository file itself is currently not supported, (cf.
  #   # http://j.mp/w7fA20). 'absent' just removes the 'enabled=0/1' line
  #   # from the .repo file.
  #   'present' => 1,
  #   'absent'  => 0,
  # }
  # yumrepo { 'jbossas_yumrepo':
  #   enabled  => $repo_enabled,
  #   name     => 'jbossas', #corresponds to the yum.conf repositoryid
  #   descr    => 'jbossas',
  #   baseurl  => 'http://example.com/fedora/rpm/$releasever/stable/$basearch/',
  #   gpgkey   => 'https://example.com/repo_signing_key.asc',
  #   gpgcheck => 1,
  # }

}
