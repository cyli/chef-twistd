# ChefSpec tests for the plugin LWRP
# stole a bunch from https://gist.github.com/jtimberman/4370569


require 'rspec'
require 'spec_helper'

require 'chef/event_dispatch/dispatcher'
require 'chef/platform'
require 'chef/provider/directory'
require 'chef/provider/service/upstart'
require 'chef/provider/template'
require 'chef/resource/service'


describe Chef::Provider::TwistdPlugin do
  before do
    @node = Chef::Node.new
    @node.set["name"] = 'plugin'
    @node.set["platform"] = 'ubuntu'
    @node.set["platform_version"] = '9.10'

    @run_context = Chef::RunContext.new(@node, {},
                                        Chef::EventDispatch::Dispatcher.new)

    @new_resource = Chef::Resource::TwistdPlugin.new('test_plugin')
    @provider = Chef::Provider::TwistdPlugin.new(@new_resource, @run_context)
  end

  describe "load_current_resource" do
    it 'should start off with authbinded as false' do
      @provider.load_current_resource
      @provider.instance_variable_get(:@authbinded).should == false
    end

    it 'should set pidfile to a sane default if not provided' do
      @provider.load_current_resource
      @provider.instance_variable_get(:@pidfile).should == "/tmp/test_plugin.twistd.pid"
    end

    it 'should set pidfile to a sane default if not provided' do
      @new_resource.instance_variable_set(:@pidfile, "/my/pid/file")
      @provider.load_current_resource
      @provider.instance_variable_get(:@pidfile).should == "/my/pid/file"
    end
  end

  describe "create" do
    before do
      @directory = Object.new
      @service = Object.new
      @template = Object.new
      Chef::Provider::Template.stub!(:new).and_return(@template)
      Chef::Resource::Service.stub!(:new).and_return(@service)
    end

    it 'test' do
      @provider.run_action(:add)
    end
  end
end
