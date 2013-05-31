# recipe to exercise twistd_plugin LWRP - this doens't exercise all the
# possible formatting options of the template, because there is a separate
# template test

twistd_plugin "root_no_args" do
  twistd_command 'plugin_command'
end

twistd_plugin "user_no_args" do
  twistd_command 'plugin_command'
  user "username"
end

# shouldn't actually authbind anything
# twistd_plugin "root_autbind_no_args" do
#   twistd_command 'plugin_command'
#   authbind_ports [80, 22]
# end

# twistd_plugin "user_autbind_no_args" do
#   twistd_command 'plugin_command'
#   user "username"
#   authbind_ports [80, 22]
# end

# twistd_plugin "root_pidfile" do
#   twistd_command 'plugin_command'
#   pidfile 'pidfile'
# end

# twistd_plugin "root_logfile" do
#   twistd_command 'plugin_command'
#   logfile 'logfile'
# end

twistd_plugin "root_args" do
  twistd_command 'plugin_command'
  args ['--option1', '--option2', '-flag1']
end
