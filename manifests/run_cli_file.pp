define jbossas::run_cli_file ($path,$unless_command) {
  exec { "cli_${name}":
    # command => "echo
    # '/server-group=${name}:add(profile=${profile},socket-binding-group=${socket_binding_group},socket-binding-port-offset=${offset})EOF'
    # |./bin/jboss-cli.sh -c",
    command  => "./jboss-cli.sh --controller=\"${jbossas::bind_address_management}\" --user=${jbossas::admin_user} --password=${jbossas::admin_user_password} --file=${jbossas::deploy_dir}/${path}${name}",
    user     => $jbossas::jboss_user,
    cwd      => "${jbossas::deploy_dir}/bin",
    provider => 'shell',
    unless   => "curl --digest -D - http://${jbossas::admin_user}:${jbossas::admin_user_password}@${jbossas::bind_address_management}:9990/management/ -d '{${unless_command}, \"json.pretty\":1}' -HContent-Type:application/json -s|grep -q success"
  #     logoutput => true,
  # require  => [Exec['extract_teiid']],
  }
  notice("curl --digest -D - http://${jbossas::admin_user}:${jbossas::admin_user_password}@${jbossas::bind_address_management}:9990/management/ -d '{${unless_command}, \"json.pretty\":1}' -HContent-Type:application/json -s|grep -q success")
}