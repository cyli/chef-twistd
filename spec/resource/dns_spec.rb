require 'rspec'
require 'spec_helper'


describe Chef::Resource::TwistdDns do

  before(:each) do
    @resource = Chef::Resource::TwistdDns.new("dns")
  end

  it "should create a new Chef::Resource::TwistdDns" do
    @resource.should be_a_kind_of(Chef::Resource)
    @resource.should be_a_kind_of(Chef::Resource::TwistdDns)
  end

  it "should set name = the first and only argument to dns" do
    @resource.name.should eql("dns")
  end

  it "should accept nil for the port" do
    @resource.port nil
    @resource.port.should eql(5353)
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
    @resource.user.should eql("dns")
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

  it "should accept nil for the secondaries" do
    @resource.secondaries nil
    @resource.secondaries.should eql(nil)
  end

  it "should accept a hash for the secondaries" do
    hash = {'thing' => 1}
    @resource.secondaries hash
    @resource.secondaries.should eql(hash)
  end

  it "should not accept an array for the secondaries" do
    lambda {
      @resource.secondaries []
    }.should raise_error(ArgumentError)
  end

  it "should accept nil for the pyzones" do
    @resource.pyzones nil
    @resource.pyzones.should eql(nil)
  end

  it "should accept an array for the pyzones" do
    @resource.pyzones [1]
    @resource.pyzones.should eql([1])
  end

  it "should not accept a hash for the pyzones" do
    lambda {
      @resource.pyzones Hash.new
    }.should raise_error(ArgumentError)
  end
  it "should accept nil for the bindzones" do
    @resource.bindzones nil
    @resource.bindzones.should eql(nil)
  end

  it "should accept an array for the bindzones" do
    @resource.bindzones [1]
    @resource.bindzones.should eql([1])
  end

  it "should not accept a hash for the bindzones" do
    lambda {
      @resource.bindzones Hash.new
    }.should raise_error(ArgumentError)
  end
end
