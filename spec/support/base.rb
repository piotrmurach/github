module SpecHelpers
  module Base

    def self.included(base)
      base.class_eval do
        let!(:github) { Github.new }
        let!(:user)   { 'peter-murach' }
        let!(:repo)   { 'github' }
        let!(:org)   { 'github' }
        let!(:collaborator) { 'octocat' }

        before(:each) do
          github.login = nil
          github.password = nil
        end
      end
    end

  end
end # SpecHelpers

RSpec.configure do |conf|
  conf.include SpecHelpers::Base, :type => :base
end
