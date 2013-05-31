# recipe to exercise twistd_web LWRP

twistd_web "root-rpy-port" do
  user node['twisted']['web']['user']
  resource_script "/srv/web/root.rpy"
  port 80
end

twistd_web "root-rpy" do
  user node['twisted']['web']['user']
  logfile node['twisted']['web']['logfile']
  pidfile node['twisted']['web']['pidfile']
  resource_script "/srv/web/root.rpy"
  port 80
end
