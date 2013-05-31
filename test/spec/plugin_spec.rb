# ChefSpec tests for the plugin LWRP

require 'chefspec'

describe 'twistd::default' do
  let(:chef_run) {
    runner = ChefSpec::ChefRunner.new({:step_into => ['twistd_plugin']})
    runner.converge 'lwrp_test::plugin'
  }

  it 'basic root upstart conf for resource root_no_args' do
    loc = '/etc/init/root_no_args.conf'
    expect(chef_run).to create_file loc
    file = chef_run.template(loc)
    expect(file).to be_owned_by('root', 'root')
  end


end
