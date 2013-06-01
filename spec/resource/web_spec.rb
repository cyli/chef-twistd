require 'rspec'
require 'spec_helper'


describe Chef::Resource::TwistdWeb do

  before(:each) do
    @resource = Chef::Resource::TwistdWeb.new("web")
  end

  it "should create a new Chef::Resource::TwistdWeb" do
    @resource.should be_a_kind_of(Chef::Resource)
    @resource.should be_a_kind_of(Chef::Resource::TwistdWeb)
  end

  it "should set name = the first and only argument to new" do
    @resource.name.should eql("web")
  end

  it "should accept nil for the port" do
    @resource.port nil
    @resource.port.should eql(8080)
  end

  it "should accept an int for the port" do
    @resource.port 9000
    @resource.port.should eql(9000)
  end

  it "should not accept a string for the port" do
    lambda {
      @resource.port '9000'
    }.should raise_error(ArgumentError)
  end

  it "should accept nil for the user" do
    @resource.user nil
    @resource.user.should eql("web")
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

  it "should accept nil for the https_port" do
    @resource.https_port nil
    @resource.https_port.should eql(nil)
  end

  it "should accept an int for the port" do
    @resource.https_port 9000
    @resource.https_port.should eql(9000)
  end

  it "should not accept a string for the https_port" do
    lambda {
      @resource.https_port '9000'
    }.should raise_error(ArgumentError)
  end

  %w[path wsgi index resource_script].each do |attr|
    it "should accept nil for the #{attr}" do
      @resource.params[attr] = nil
      @resource.params[attr].should eql(nil)
    end

    it "should accept a string for the #{attr}" do
      @resource.params[attr] = "attribute"
      @resource.params[attr].should eql("attribute")
    end
  end
end
