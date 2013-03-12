define jbossas::add_server($jbhost_name = 'master', $server_group = 'dummy', $port_offset = "0", $autostart='false', $deploy_dir='/usr/share/jboss-as'){
	exec {
		"add_server_${jbhost_name}_${name}" :
			command => "echo '/host=${jbhost_name}/server-config=${name}:add(group=${server_group},socket-binding-port-offset=${port_offset},auto-start=${autostart})EOF' |./bin/jboss-cli.sh -c",
			user => 'jbossas',
			cwd => "${deploy_dir}",
			provider => 'shell',
#			logoutput => true,
	}
	notice("/host=${jbhost_name}/server-config=${name}:add(group=${server_group},socket-binding-port-offset=${port_offset},auto-start=${autostart})")
	#/host=jbmaster/server-config=server-test:add(group=test,auto-start=true)
	#/host=${jbhost_name}/server-config=${name}:add(group=${server_group},socket-binding-port-offset=${port_offset},auto-start=${autostart})
}
