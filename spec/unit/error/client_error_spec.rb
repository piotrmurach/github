# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Error::ClientError do
  describe '#generate_message' do
    let(:error) { described_class.new('message') }
    let(:attributes) do
      {
        :problem => 'Oh no!',
        :summary => 'Fix this!',
        :resolution => 'Glue it!'
      }
    end

    it 'generates problem line' do
      expect(error.generate_message(attributes)).to include "Problem:\n Oh no!"
    end

    it 'generates summary line' do
      expect(error.generate_message(attributes)).to include "Summary:\n Fix this!"
    end

    it 'generates resolution line' do
      expect(error.generate_message(attributes)).to include "Resolution:\n Glue it!"
    end

    before do
      error.generate_message(attributes)
    end

    describe '#problem' do
      it 'returns problem' do
        expect(error.problem).to eq attributes[:problem]
      end
    end

    describe '#summary' do
      it 'returns summary' do
        expect(error.summary).to eq attributes[:summary]
      end
    end

    describe '#resolution' do
      it 'returns resolution' do
        expect(error.resolution).to eq attributes[:resolution]
      end
    end
  end
end # Github::Error::ClientError
