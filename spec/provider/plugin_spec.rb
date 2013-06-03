# ChefSpec tests for the plugin LWRP

require 'spec_helper'

require 'chefspec'

require 'chef/event_dispatch/dispatcher'
require 'chef/resource/template'
require 'chef/run_context'

class Chef
  class Resource
    class AuthbindPort < Chef::Resource
    end
  end
end

class Chef
  class Provider
    class AuthbindPort < Chef::Provider
    end
  end
end


# https://github.com/acrmp/chefspec/issues/107
def check_template(resource, variables)
  resource.cookbook.should be == 'twistd'
  resource.source.should be == "twistd_plugin.conf.erb"
  resource.owner.should be == "root"
  resource.group.should be == "root"
  resource.mode.should be == 0644

  resource.variables.should be == variables

  resource.action.should be == [:nothing]
end


describe Chef::Provider::TwistdPlugin do
  let(:cookbook_paths) {[
    File.expand_path('../../..', __FILE__),
    File.expand_path('../fixtures', __FILE__)
  ]}
  let(:runner) {
    ChefSpec::ChefRunner.new(
      :cookbook_path => cookbook_paths,
      :step_into => ['twistd_plugin'])
  }

  describe "variables passed to template" do
    it 'should pass default arguments if only command given' do
      runner.converge "fixtures::plugin_basic"
      resource = runner.find_resource('template',
                                      '/etc/init/command_only.conf')
      check_template(resource, {
        :service_name => 'command_only',
        :authbinded => false,
        :user => 'root',
        :logfile => nil,
        :pidfile => '/tmp/command_only.twistd.pid',
        :twistd_command => 'my_plugin',
        :args => []
      })
    end

    it 'should pass the given user' do
      runner.converge "fixtures::plugin_with_user"
      resource = runner.find_resource('template',
                                      '/etc/init/command_and_user.conf')
      check_template(resource, {
        :service_name => 'command_and_user',
        :authbinded => false,
        :user => 'my_user',
        :logfile => nil,
        :pidfile => '/tmp/command_and_user.twistd.pid',
        :twistd_command => 'my_plugin',
        :args => []
      })
    end

    it 'should pass the given logfile and pidfile' do
      runner.converge "fixtures::plugin_files"
      resource = runner.find_resource('template',
                                      '/etc/init/logfile_pidfile.conf')
      check_template(resource, {
        :service_name => 'logfile_pidfile',
        :authbinded => false,
        :user => 'root',
        :logfile => '/tmp/mylogfile',
        :pidfile => '/tmp/mypidfile',
        :twistd_command => 'my_plugin',
        :args => []
      })
    end

    it 'should pass the provided args' do
      runner.converge "fixtures::plugin_with_args"
      resource = runner.find_resource('template',
                                      '/etc/init/list_of_args.conf')
      check_template(resource, {
        :service_name => 'list_of_args',
        :authbinded => false,
        :user => 'root',
        :logfile => nil,
        :pidfile => '/tmp/list_of_args.twistd.pid',
        :twistd_command => 'my_plugin',
        :args => ['--arg1', '--arg2']
      })
    end
  end

  describe "support authbind", :skip => true do
    before do
      @events = Chef::EventDispatch::Dispatcher.new
      @run_context = Chef::RunContext.new(runner.node, {}, @events)
      @authbind = Chef::Resource::AuthbindPort.new(@run_context)
      Chef::Resource::AuthbindPort.stub!(:new).and_return(@authbind)
    end

    it 'should authbind if the user is not root and the ports < 1024' do
      runner.converge "fixtures::plugin_authbind"
      check_template(runner.resources, {
        :service_name => 'authbind',
        :authbinded => true,
        :user => 'my_user',
        :logfile => nil,
        :pidfile => '/tmp/command_and_user.twistd.pid',
        :twistd_command => 'my_plugin',
        :args => []
      })
    end

    it 'should not authbind if the user is root' do
      runner.converge "fixtures::plugin_root_authbind"
      check_template(runner.resources, {
        :service_name => 'root_authbind',
        :authbinded => false,
        :user => 'root',
        :logfile => nil,
        :pidfile => '/tmp/command_and_user.twistd.pid',
        :twistd_command => 'my_plugin',
        :args => []
      })
    end

    it 'should not authbind if the ports >= 1024' do
      runner.converge "fixtures::plugin_authbind_high_port"
      check_template(runner.resources, {
        :service_name => 'authbind_high_port',
        :authbinded => false,
        :user => 'my_user',
        :logfile => nil,
        :pidfile => '/tmp/command_and_user.twistd.pid',
        :twistd_command => 'my_plugin',
        :args => []
      })
    end
  end
end
