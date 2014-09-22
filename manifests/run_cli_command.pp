define jbossas::run_cli_command ($command, $unless_command = undef) {
  if $unless_command{
    $unless_cmd = "curl --digest -D - http://${jbossas::admin_user}:${jbossas::admin_user_password}@${jbossas::bind_address_management}:9990/management/ -d '{${unless_command}, \"json.pretty\":1}' -HContent-Type:application/json -s|grep -q success"
  }else{
#    $unless_cmd = "echo 'ok'"  (with this since the unless avaluated true it never executed the command
    $unless_cmd = "eval false" #will always execute the command
  }
  
  
  exec { "cli_${name}":
    # command => "echo
    # '/server-group=${name}:add(profile=${profile},socket-binding-group=${socket_binding_group},socket-binding-port-offset=${offset})EOF'
    # |./bin/jboss-cli.sh -c",
    command  => "./jboss-cli.sh -c --controller=\"${jbossas::bind_address_management}\" --user=${jbossas::admin_user} --password=${jbossas::admin_user_password} --command='${command}'",
    user     => $jbossas::jboss_user,
    cwd      => "${jbossas::deploy_dir}/bin",
    provider => 'shell',
    unless   => $unless_cmd
  #     logoutput => true,
  # require  => [Exec['extract_teiid']],
  }
  notice("./jboss-cli.sh -c --controller=\"${jbossas::bind_address_management}\" --user=${jbossas::admin_user} --password=${jbossas::admin_user_password} --command='${command}'"
  )
  notice("${jbossas::deploy_dir}/bin")
  notice("${unless_cmd}")
}