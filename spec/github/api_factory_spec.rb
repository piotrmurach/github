require 'spec_helper'

describe Github::ApiFactory, :type => :base do

  context '#new' do
    it 'throws error if klass type is ommitted' do
      expect { described_class.new nil }.to raise_error(ArgumentError)
    end

    it 'instantiates a new object' do
      described_class.new('Repos').should be_a Github::Repos
    end
  end
end # Github::ApiFactory
