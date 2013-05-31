require "chefspec"

describe "twistd::default" do
  before do
    @chef_run = ::ChefSpec::ChefRunner.new.converge "twistd::default"
  end

  it "installs package" do
    @chef_run.should install_package "python-twisted"
  end
end
