twistd_plugin "logfile_pidfile" do
  twistd_command "my_plugin"
  logfile "/tmp/mylogfile"
  pidfile "/tmp/mypidfile"
end
