# encoding: utf-8

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

Cucumber::Rake::Task.new(:features)

FileList['tasks/**/*.rake'].each(&method(:import))

task default: [:spec, :features]

desc 'Run all specs on CI'
task ci: [:spec, :features, 'coveralls:push']

desc 'Load gem inside irb console'
task :console do
  require 'irb'
  require 'irb/completion'
  require File.join(__FILE__, '../lib/github_api')
  ARGV.clear
  IRB.start
end
