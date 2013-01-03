def load_current_resource
  @authbinded = false
  @pidfile = new_resource.pidfile || "/tmp/#{new_resource.name}.twistd.pid"
end

action :add do
  authbind_ports      :create
  log_dir             :create
  upstart_service     :create
end


action :remove do
  upstart_service     :delete
  log_dir             :delete
  authbind_ports      :delete
end


# authbind (or unbind) the ports that need to be authbinded
def authbind_ports(exec_action)
  unless new_resource.user.nil? then
    ports = new_resource.authbind_ports || []
    ports.each do |a_port|
      r = authbind_port "#{exec_action}:#{a_port}:#{new_resource.user}" do
        port a_port
        user new_resource.user
        group new_resource.user
        only_if {
          exec_action == :delete ||
          (a_port < 1024 && new_resource.user != "root")
        }
        action :nothing
      end
      r.run_action(exec_action == :delete ? :remove : :add)

      if r.updated_by_last_action? then
        new_resource.updated_by_last_action(true)
        Chef::Log::info("#{exec_action} authbind port #{a_port} to user #{new_resource.user} for twistd service #{new_resource.name}")
      end

      @authbinded = (
        @authbinded || (a_port < 1024 && new_resource.user != "root"))
    end
  end
end


# create or delete the log directory
def log_dir(exec_action)
  dirs = [new_resource.logfile, new_resource.pidfile].map{
    |x| ::File.dirname(x) if x && !::File.exists?(x)
  }.compact

  dirs.each do |dirpath|
    r = directory dirpath do
      mode 0755
      owner new_resource.user
      group new_resource.user
      recursive true if exec_action == :create
      action :nothing
    end
    r.run_action(exec_action)
    new_resource.updated_by_last_action(true) if r.updated_by_last_action?
  end
end


  # create or delete upstart configuration for the service
def upstart_service(exec_action)
  s = service new_resource.name do
    case node[:platform]
    when "ubuntu"
      if node[:platform_version].to_f >= 9.10 then
        provider Chef::Provider::Service::Upstart
      end
    end
    action :nothing
  end

  if exec_action == :delete then
    s.run_action(:stop)
    s.run_action(:disable)
    r = file "/etc/init/#{new_resource.name}.conf" do
      action :nothing
    end
    r.run_action(:delete)
    new_resource.updated_by_last_action(true) if r.updated_by_last_action?
  else
    # don't mess up scope with instance variables
    authbinded = @authbinded
    pidfile = @pidfile

    r = template "/etc/init/#{new_resource.name}.conf" do
      cookbook "twistd"
      source "twistd_plugin.conf.erb"
      owner "root"
      group "root"
      mode 0644
      variables({
        :service_name => new_resource.name,
        :authbinded => authbinded,
        :user => new_resource.user || "root",
        :logfile => new_resource.logfile,
        :pidfile => pidfile,
        :twistd_command => new_resource.twistd_command,
        :args => new_resource.args || []
      })
      action :nothing
    end
    r.run_action(:create)
    s.run_action(:enable)
    if r.updated_by_last_action? then
      new_resource.updated_by_last_action(true)
      s.run_action(:restart)
    else
      s.run_action(:start)
    end
  end
end
