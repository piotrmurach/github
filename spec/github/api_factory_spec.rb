# encoding: utf-8

require 'spec_helper'

describe Github::ApiFactory do

  context '#new' do
    it 'throws error if klass type is ommitted' do
      expect { described_class.new nil }.to raise_error(ArgumentError)
    end

    it 'instantiates a new object' do
      described_class.new('Repos').should be_a Github::Repos
    end
  end

  context '#create_instance' do
    it 'sets api client' do
      instance = Github::Issues::Labels.new
      Github.should_receive(:api_client=).twice().and_return instance
      described_class.create_instance('Issues::Labels', {})
    end
  end

  context '#convert_to_constant' do
    it 'knows how to convert nested classes' do
      described_class.convert_to_constant('Issues::Labels').
        should == Github::Issues::Labels
    end
  end
end # Github::ApiFactory
