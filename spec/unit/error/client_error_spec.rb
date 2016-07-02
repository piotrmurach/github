# encoding: utf-8

require 'spec_helper'

describe Github::Error::ClientError do
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
      error.generate_message(attributes).should include "Problem:\n Oh no!"
    end

    it 'generates summary line' do
      error.generate_message(attributes).should include "Summary:\n Fix this!"
    end

    it 'generates resolution line' do
      error.generate_message(attributes).should include "Resolution:\n Glue it!"
    end

    before do
      error.generate_message(attributes)
    end

    describe '#problem' do
      it 'returns problem' do
        error.problem.should eq attributes[:problem]
      end
    end

    describe '#summary' do
      it 'returns summary' do
        error.summary.should eq attributes[:summary]
      end
    end

    describe '#resolution' do
      it 'returns resolution' do
        error.resolution.should eq attributes[:resolution]
      end
    end
  end
end # Github::Error::ClientError
