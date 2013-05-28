#!/usr/bin/env rake

require 'foodcritic'
require 'rake/testtask'

FoodCritic::Rake::LintTask.new do |t|
  t.options = { :fail_tags => ['any'] }
end

Rake::TestTask.new do |i|
  i.pattern = 'test/test_*.rb'
  i.verbose = true
end

task :default => [:foodcritic]
task :lint => [:foodcritic]
