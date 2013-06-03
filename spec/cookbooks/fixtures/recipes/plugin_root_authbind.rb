twistd_plugin "root_authbind" do
  twistd_command "my_plugin"
  authbind_ports [80, 88]
end
