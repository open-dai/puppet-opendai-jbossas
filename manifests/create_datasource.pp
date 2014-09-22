define jbossas::create_datasource ($profile, $jndi_name, $driver, $username, $password, $connection) {
  # this is to create a data source ...
  # /profile=ha/subsystem=datasources/data-source=reportsDS:add(jndi-name="java:/Reports",  driver-name="mysql",
  # driver-class="com.mysql.jdbc.Driver", connection-url="jdbc:mysql://195.84.86.39:3306/reports", user-name="root",
  # password="Open-Dai2012")
  case $driver {
    mysql      : { $driver_class = "com.mysql.jdbc.Driver" }
    postgresql : { $driver_class = "org.postgresql.Driver" }
    oracle     : { $driver_class = "oracle.jdbc.driver.OracleDriver" }
    default    : { $driver_class = "" }
  }
  $cli_datasource_command = "/profile=${profile}/subsystem=datasources/data-source=${name}:add(jndi-name=\"${jndi_name}\",  driver-name=\"${driver}\", driver-class=\"${driver_class}\", connection-url=\"${connection}\", user-name=\"${username}\", password=\"${password}\")"

  jbossas::run_cli_command { "create_${name}_${profile}_datasource":
    command        => $cli_datasource_command,
    unless_command => "\"operation\":\"read-resource\", \"include-runtime\":\"true\", \"address\":[{\"profile\":\"${profile}\"},{\"subsystem\":\"datasources\"},{\"data-source\":\"${name}\"}]",
  #    require        => [Exec['download_${name}_driver']],
  }
}
