# encoding: utf-8

begin
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
rescue LoadError
  namespace :coveralls do
    task :push do
      abort "Task coveralls:push is not available"
    end
  end
end
