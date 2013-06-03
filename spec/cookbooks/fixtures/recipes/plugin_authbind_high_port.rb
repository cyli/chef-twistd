twistd_plugin "authbind_high_port" do
  twistd_command "my_plugin"
  user "my_user"
  authbind_ports [5000, 6000]
end
