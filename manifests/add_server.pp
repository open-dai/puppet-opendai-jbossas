define jbossas::add_server (
  $jbhost_name  = 'master',
  $server_group = 'dummy',
  $port_offset  = "0",
  $autostart    = 'false',
  ) {
  exec { "add_server_${jbhost_name}_${name}":
    # command => "echo
    # '/host=${jbhost_name}/server-config=${name}:add(group=${server_group},socket-binding-port-offset=${port_offset},auto-start=${autostart})EOF'
    # |./bin/jboss-cli.sh -c",
    command  => "${jbossas::deploy_dir}/bin/jboss-cli.sh -c --controller=\"${jbossas::bind_address_management}\" --user=${jbossas::admin_user} --password=${jbossas::admin_user_password} --command=\"/host=${jbhost_name}/server-config=${name}:add(group=${server_group},socket-binding-port-offset=${port_offset},auto-start=${autostart})\"",
    user     => $jbossas::jboss_user,
    cwd      => "${jbossas::deploy_dir}",
    provider => 'shell',
    unless   => "curl --digest -D - http://${jbossas::admin_user}:${jbossas::admin_user_password}@${jbossas::bind_address_management}:9990/management/ -d '{\"operation\":\"read-resource\", \"include-runtime\":\"true\", \"address\":[{\"host\":\"${jbhost_name}\"},{\"server-config\":\"${name}\"}], \"json.pretty\":1}' -HContent-Type:application/json -s|grep -q success"
  # 		logoutput => true,
  }
  notice("./bin/jboss-cli.sh -c --controller=\"${jbossas::bind_address_management}\" --user=${jbossas::admin_user} --password=${jbossas::admin_user_password} --command=\"/host=${jbhost_name}/server-config=${name}:add(group=${server_group},socket-binding-port-offset=${port_offset},auto-start=${autostart})\""
  )
  notice("curl --digest -D - http://${jbossas::admin_user}:${jbossas::admin_user_password}@${jbossas::bind_address_management}:9990/management/ -d '{\"operation\":\"read-resource\", \"include-runtime\":\"true\", \"address\":[{\"host\":\"${jbhost_name}\"},{\"server-config\":\"${name}\"}], \"json.pretty\":1}' -HContent-Type:application/json -s|grep -q success"
  )
  # /host=jbmaster/server-config=server-test:add(group=test,auto-start=true)
  # /host=${jbhost_name}/server-config=${name}:add(group=${server_group},socket-binding-port-offset=${port_offset},auto-start=${autostart})
  # /opt/jboss/bin/jboss-cli.sh -c --controller="10.1.1.77" --user=admin --password=opendaiadmin
  # --command="/host=master/server-config=teiid1:add(group=teiid-server-group,socket-binding-port-offset=0,auto-start=false)"
}
