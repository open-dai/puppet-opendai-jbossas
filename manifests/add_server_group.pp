define jbossas::add_server_group (
  $profile              = 'ha',
  $socket_binding_group = 'ha-socket',
  $offset               = '0',
  $deploy_dir           = '/usr/share/jboss-as') {
  exec { "add_jboss_server_group_${name}":
    # command => "echo
    # '/server-group=${name}:add(profile=${profile},socket-binding-group=${socket_binding_group},socket-binding-port-offset=${offset})EOF'
    # |./bin/jboss-cli.sh -c",
    command  => "./bin/jboss-cli.sh -c --controller=\"${jbossas::bind_address_management}\" --user=${jbossas::admin_user} --password=${jbossas::admin_user_password} --command=\"/server-group=${name}:add(profile=${profile},socket-binding-group=${socket_binding_group},socket-binding-port-offset=${offset})\"",
    user     => $jbossas::jboss_user,
    cwd      => "${deploy_dir}",
    provider => 'shell',
    unless   => "curl --digest -D - http://${jbossas::admin_user}:${jbossas::admin_user_password}@${jbossas::bind_address_management}:9990/management/ -d '{\"operation\":\"read-resource\", \"include-runtime\":\"true\", \"address\":[{\"server-group\":\"${name}\"}], \"json.pretty\":1}' -HContent-Type:application/json -s|grep -q success"
  # 		logoutput => true,
  }
  notice("./bin/jboss-cli.sh -c --controller=\"${jbossas::bind_address_management}\" --user=${jbossas::admin_user} --password=${jbossas::admin_user_password} --command=\"/server-group=${name}:add(profile=${profile},socket-binding-group=${socket_binding_group},socket-binding-port-offset=${offset})\""
  )
  notice("curl --digest -D - http://${jbossas::admin_user}:${jbossas::admin_user_password}@${jbossas::bind_address_management}:9990/management/ -d '{\"operation\":\"read-resource\", \"include-runtime\":\"true\", \"address\":[{\"server-group\":\"${name}\"}], \"json.pretty\":1}' -HContent-Type:application/json -s|grep -q success"
  )
  # /server-group=test:add(profile=ha,socket-binding-group=ha-sockets,socket-binding-port-offset=200)
  # /server-group=${name}:add(profile=${profile},socket-binding-group=${socket_binding_group},socket-binding-port-offset=${offset})
  # echo "/server-group=test:add(profile=ha,socket-binding-group=ha-sockets)EOF" |./bin/jboss-cli.sh -c
  # curl --digest -D - http://admin:opendaiadmin@10.1.1.77:9990/management/ -d '{"operation":"read-resource",
  # "include-runtime":"true", "address":[{"server-group":"teiid-server-group"}], "json.pretty":1}' -HContent-Type:application/json
  # -s|grep -q success
}
