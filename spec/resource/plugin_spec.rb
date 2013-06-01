require 'rspec'
require 'spec_helper'


describe Chef::Resource::TwistdPlugin do

  before(:each) do
    @resource = Chef::Resource::TwistdPlugin.new("plugin_name")
  end

  it "should create a new Chef::Resource::TwistdPlugin" do
    @resource.should be_a_kind_of(Chef::Resource)
    @resource.should be_a_kind_of(Chef::Resource::TwistdPlugin)
  end

  it "should set name = the first and only argument to new" do
    @resource.name.should eql("plugin_name")
  end

  it "should accept a string for the twistd_command" do
    @resource.twistd_command "command"
    @resource.twistd_command.should eql("command")
  end

  it "should not accept nil for the twistd_command" do
    lambda {
      @resource.twistd_command nil
    }.should raise_error(ArgumentError)
  end

  it "should accept nil for the args" do
    @resource.args nil
    @resource.args.should eql([])
  end

  it "should accept an array for the args" do
    @resource.args ["arg1"]
    @resource.args.should eql(["arg1"])
  end

  it "should not accept a string for the args" do
    lambda {
      @resource.args "arg1"
    }.should raise_error(ArgumentError)
  end

  it "should accept nil for the authbind_ports" do
    @resource.authbind_ports nil
    @resource.authbind_ports.should eql([])
  end

  it "should accept an array for the authbind_ports" do
    @resource.authbind_ports [1, 2, 3]
    @resource.authbind_ports.should eql([1, 2, 3])
  end

  it "should not accept an int for the autbind_ports" do
    lambda {
      @resource.args 5
    }.should raise_error(ArgumentError)
  end

  it "should accept nil for the pidfile" do
    @resource.pidfile nil
    @resource.pidfile.should eql(nil)
  end

  it "should accept an string for the pidfile" do
    @resource.pidfile "pidfile"
    @resource.pidfile.should eql("pidfile")
  end

  it "should accept nil for the logfile" do
    @resource.logfile nil
    @resource.logfile.should eql(nil)
  end

  it "should accept an string for the logfile" do
    @resource.logfile "logfile"
    @resource.logfile.should eql("logfile")
  end

  it "should accept nil for the user" do
    @resource.user nil
    @resource.user.should eql("root")
  end

  it "should accept a string that matches the regexp for the user" do
    @resource.user "user"
    @resource.user.should eql("user")
  end

  it "should not accept a string not matching the regexp for the user" do
    lambda {
      @resource.user "hey there"
    }.should raise_error(ArgumentError)
  end
end
