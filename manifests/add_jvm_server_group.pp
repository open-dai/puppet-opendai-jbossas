define jbossas::add_jvm_server_group($heap_size = '64m', $max_heap_size = '1024m', $deploy_dir='/usr/share/jboss-as'){
	exec {
		"add_jboss_jvm_server_group_${name}" :
			#command => "echo '/server-group=${name}/jvm=default:add(heap-size=${heap_size},max-heap-size=${max_heap_size})EOF' |./bin/jboss-cli.sh -c",
			command => "./bin/jboss-cli.sh -c --controller=\"${jbossas::bind_address_management}\" --user=${jbossas::admin_user} --password=${jbossas::admin_user_password} --command=\"/server-group=${name}/jvm=default:add(heap-size=${heap_size},max-heap-size=${max_heap_size})\"",
			user => 'jbossas',
			cwd => "${deploy_dir}",
			provider => 'shell',
			unless   => "curl --digest -D - http://${jbossas::admin_user}:${jbossas::admin_user_password}@${jbossas::bind_address_management}:9990/management/ -d '{\"operation\":\"read-resource\", \"include-runtime\":\"true\", \"address\":[{\"server-group\":\"${name}\"},{\"jvm\":\"default\"}], \"json.pretty\":1}' -HContent-Type:application/json -s|grep -q success"
#			logoutput => true,
	}
	notice("/server-group=${name}/jvm=default:add(heap-size=${heap_size},max-heap-size=${max_heap_size})")
	#/server-group=test/jvm=default:add(heap-size=64m,max-heap-size=1024m)
	#/server-group=${name}/jvm=default:add(heap-size=${heap-size},max-heap-size=${max-heap-size})
	#echo "/server-group=test:add(profile=ha,socket-binding-group=ha-sockets)EOF" |./bin/jboss-cli.sh -c
}
