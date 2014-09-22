define jbossas::extract_in_jboss ($source, $creates) {
  exec { "extract_in_jboss_${name}":
    command   => "/usr/bin/unzip -u -o '${source}' -d ${jbossas::deploy_dir}",
    creates   => "${jbossas::deploy_dir}/${creates}",
    cwd       => $jbossas::deploy_dir,
    user      => $jbossas::jboss_user,
    group     => $jbossas::jboss_group,
    logoutput => true,
  #       unless => "/usr/bin/test -d '$jbossas::deploy_dir'",
  #    require   => [Group['jbossas'], User['jbossas'], Exec['download_teiid']]
  }

}