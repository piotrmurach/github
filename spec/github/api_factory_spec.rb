# encoding: utf-8

require 'spec_helper'

describe Github::API::Factory do

  subject(:factory) { described_class }

  context '#new' do
    it 'throws error if klass type is ommitted' do
      expect { factory.new nil }.to raise_error(ArgumentError)
    end

    it 'instantiates a new object' do
      expect(factory.new('Client::Repos')).to be_a Github::Client::Repos
    end
  end

  context '#create_instance' do
    it 'creates class instance' do
      expect(factory.create_instance('Client::Issues::Labels', {})).to be_kind_of(Github::Client::Issues::Labels)
    end
  end

  context '#convert_to_constant' do
    it 'knows how to convert nested classes' do
      expect(factory.convert_to_constant('Client::Issues::Labels')).to eql(Github::Client::Issues::Labels)
    end
  end
end # Github::ApiFactory
