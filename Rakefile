# encoding: utf-8

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

Cucumber::Rake::Task.new(:features)

FileList['tasks/**/*.rake'].each { |task| import task }

task :default => [:spec, :features]
