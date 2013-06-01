# ChefSpec tests for the plugin LWRP
# https://coderwall.com/p/afdnyw - tip for how to test code that executes at
# compile

require 'chefspec'

describe 'twistd::default' do
  let(:chef_run) {
    runner = ChefSpec::ChefRunner.new({
      :platform => 'ubuntu',
      :version => '12.04',
      :step_into => ['twistd_plugin']
    })
    runner.converge 'lwrp_test::plugin'
  }
  let(:node) { runner.node }
  let
  before(:each) do
    @events = Chef::EventDispatch::Dispatcher.new
    @run_context = Chef::RunContext.new(runner.node, {}, @events)
    @new_resource = Chef::Resource::Service.new("upstart")
  end

  it 'basic root upstart conf for resource root_no_args' do
    # because those resources are created at compile time:
    chef_run.resources.find {
      |r| r.name == 'root_no_args'}.old_run_action(:create)
    loc = '/etc/init/root_no_args.conf'
    expect(chef_run).to create_file loc
    file = chef_run.template(loc)
    expect(file).to be_owned_by('root', 'root')
  end


end
