module SpecHelpers
  module Base

    def self.included(base)
      base.class_eval do
        let(:github) { Github.new }
        let(:user)   { 'peter-murach' }
        let(:repo)   { 'github' }
      end
    end

  end
end # SpecHelpers
