# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Error::Validations do
  describe '#message' do
    let(:error) { described_class.new(:username => nil) }

    it 'contains the problem in the message' do
      expect(error.message).to match(/Attempted to send request with nil arguments/)
    end

    it 'contains the summary in the message' do
      expect(error.message).to match(/Each request expects certain number of required arguments./)
    end

    it 'contains the resolution in the message' do
      expect(error.message).to match(/Double check that the provided arguments are set to some value/)
    end
  end
end # Github::Error::Validations
