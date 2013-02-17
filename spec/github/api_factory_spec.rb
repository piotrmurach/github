# encoding: utf-8

require 'spec_helper'

describe Github::ApiFactory do

  subject(:factory) { described_class }

  context '#new' do
    it 'throws error if klass type is ommitted' do
      expect { factory.new nil }.to raise_error(ArgumentError)
    end

    it 'instantiates a new object' do
      expect(factory.new('Repos')).to be_a Github::Repos
    end
  end

  context '#create_instance' do
    it 'creates class instance' do
      expect(factory.create_instance('Issues::Labels', {})).to be_kind_of(Github::Issues::Labels)
    end
  end

  context '#convert_to_constant' do
    it 'knows how to convert nested classes' do
      expect(factory.convert_to_constant('Issues::Labels')).to eql Github::Issues::Labels
    end
  end
end # Github::ApiFactory
