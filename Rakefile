#!/usr/bin/env rake

require 'foodcritic'
require 'rake'
require 'rspec/core/rake_task'

FoodCritic::Rake::LintTask.new do |t|
  t.options = { :fail_tags => ['any'] }
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.fail_on_error = false
  t.rspec_opts = ['-f d']
end

task :default => [:spec]
task :lint => [:foodcritic]
