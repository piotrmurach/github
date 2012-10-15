begin
  require 'reek/rake/task'

  namespace :metrics do
    Reek::Rake::Task.new
  end
rescue LoadError
  task :reek do
    abort "Reek is not available. In order to run reek, you must: gem install reek"
  end
end
