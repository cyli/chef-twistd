def load_current_resource
  @secondaries = new_resource.secondaries || []
  @pyzones = new_resource.pyzones || []
  @bindzones = new_resource.bindzones || []
end

action :add do
  dns_plugin_resource :add
end


action :remove do
  dns_plugin_resource :remove
end


def dns_plugin_resource(exec_action)
  args = (
    @secondaries.each_pair.map { |domain, ip|"--secondary #{domain}/#{ip}" } +
    @pyzones.each.map { |pyzone| "--pyzone #{pyzone}" } +
    @bindzones.each.map { |bindzone|"--bindzone #{bindzone}" }
  )

  r = twistd_plugin new_resource.name do
    user new_resource.user

    log_dir new_resource.log_dir

    authbind_ports [new_resource.port || 53]
    twistd_command "dns"
    args args
    action :nothing
  end
  r.run_action(exec_action)
  new_resource.updated_by_last_action(true) if r.updated_by_last_action?
end
