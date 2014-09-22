define jbossas::set_mod_cluster ($proxy_name, $port, $profile = 'ha',$balancer) {
# $name is the proxy name
  $cli_command1 = "/profile=${profile}/subsystem=modcluster/mod-cluster-config=configuration:write-attribute(name=proxy-list,value=${proxy_name}:${port})"
#  $cli_command2 = "/profile=${profile}/subsystem=modcluster/mod-cluster-config=configuration:write-attribute(name=balancer,value=${balancer})"
  $var1='"${mycluster.modcluster.balancer'
  $cli_command2 = "/profile=${profile}/subsystem=modcluster/mod-cluster-config=configuration:write-attribute(name=balancer,value=${var1}:${balancer}}\""
  $var2='"${mycluster.modcluster.lbgroup'
  $cli_command3 = "/profile=${profile}/subsystem=modcluster/mod-cluster-config=configuration:write-attribute(name=${jbossas::load_balancer_group},value=${var2}:StdLBGroup}\""

  jbossas::run_cli_command { "set_${proxy_name}_${profile}_cluster_proxy":
    command        => $cli_command1,
#    unless_command => "\"operation\":\"read-attribute\", \"name\":\"proxy-list\", \"address\":[{\"profile\":\"${profile}\"},{\"subsystem\":\"modcluster\"},{\"mod-cluster-config\":\"configuration\"}]",
    require => Class['jbossas'], 
  }

  jbossas::run_cli_command { "set_${proxy_name}_${profile}_cluster_proxy_balancer":
    command        => $cli_command2,
#    unless_command => "\"operation\":\"read-attribute\", \"name\":\"balancer\", \"address\":[{\"profile\":\"${profile}\"},{\"subsystem\":\"modcluster\"},{\"mod-cluster-config\":\"configuration\"}]",
    require => Class['jbossas'],
  }

  jbossas::run_cli_command { "set_${proxy_name}_${profile}_cluster_proxy_domain":
    command        => $cli_command3,
#    unless_command => "\"operation\":\"read-attribute\", \"name\":\"${jbossas::load_balancer_group}\", \"address\":[{\"profile\":\"${profile}\"},{\"subsystem\":\"modcluster\"},{\"mod-cluster-config\":\"configuration\"}]",
    require => Class['jbossas'],
  }
}