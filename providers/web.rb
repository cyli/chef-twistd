def load_current_resource
  @web_resource = ["path", "wsgi", "index", "resource_script"].select {
    |item| !new_resource.instance_variable_get("@#{item}").nil?
  }

  if @web_resource.length != 1
    raise "Exactly one of 'path', 'wsgi', 'index', or 'resource_script' must be provided."
  else
    @web_resource = @web_resource.first
  end
end

action :add do
  web_plugin_resource :add
end


action :remove do
  web_plugin_resource :remove
end


def web_plugin_resource(exec_action)
  ports = [new_resource.port]
  if new_resource.https_port then
      ports += [new_resource.https_port]
  end

  web_resource_option = @web_resource.sub(/_/, '-')
  web_resource_value = new_resource.instance_variable_get("@#{@web_resource}")

  args = ["--port #{new_resource.port}",
          "--#{web_resource_option} #{web_resource_value}"]

  r = twistd_plugin new_resource.name do
    user new_resource.user
    log_dir new_resource.log_dir
    authbind_ports ports
    twistd_command "web"
    args args
    action :nothing
  end
  r.run_action(exec_action)
  new_resource.updated_by_last_action(true) if r.updated_by_last_action?
end
