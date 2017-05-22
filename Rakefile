# encoding: utf-8
require "bundler/gem_tasks"

require 'rake/testtask'
desc 'Run test_unit based test'
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = Dir["test/**/test_*.rb"].sort
  t.verbose = true
  #t.warning = true
end
task :default => :test
task :test => [:compile]

desc 'Open an irb session preloaded with the gem library'
task :console do
  sh 'irb -rubygems -I lib'
end
task :c => :console

task :compile do
  sh 'racc lib/fluent/plugin/filter_where/parser.racc'
  sh 'rex lib/fluent/plugin/filter_where/parser.rex'
end
