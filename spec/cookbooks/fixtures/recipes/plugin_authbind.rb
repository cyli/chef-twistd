twistd_plugin "authbind" do
  twistd_command "my_plugin"
  user "my_user"
  authbind_ports [80, 88]
end
