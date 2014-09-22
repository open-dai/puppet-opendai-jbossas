define jbossas::install_teiid_domain ($version="8.3") {
  $server_group = $name

  file { "${jbossas::deploy_dir}/bin/scripts/teiid-domain-mode-install.cli":
    content => template("jbossas/TEIID/${version}/teiid-domain-mode-install.cli.erb"),
    owner   => $jbossas::jboss_user,
    group   => $jbossas::jboss_group,
    mode    => 0755,
  }

  jbossas::run_cli_file { 'teiid-domain-mode-install.cli':
    path    => 'bin/scripts/',
    unless_command=> "\"operation\":\"read-resource\", \"include-runtime\":\"true\", \"address\":[{\"profile\":\"ha\"},{\"subsystem\":\"teiid\"}]",
    require => File["${jbossas::deploy_dir}/bin/scripts/teiid-domain-mode-install.cli"]
  }
}