require 'chef/cookbook/metadata'
require 'chef/provider'
require 'chef/resource'
require 'chef/run_context'


md = Chef::Cookbook::Metadata.new
md.from_file(File.join(File.dirname(__FILE__), %w[.. metadata.rb]))


Chef::Resource.build_from_file(
  md.name,
  File.join(File.dirname(__FILE__), %w[.. resources plugin.rb]),
  @run_context)
Chef::Provider.build_from_file(
  md.name,
  File.join(File.dirname(__FILE__), %w[.. providers plugin.rb]),
  @run_context)
