# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Error::InvalidOptions do
  describe '#message' do
    let(:error) { described_class.new({:invalid => true}, [:valid]) }

    it 'contains the problem in the message' do
      expect(error.message).to include "Invalid option invalid provided for this request."
    end

    it 'contains the summary in the message' do
      expect(error.message).to include "Github gem checks the request parameters passed to ensure that github api is not hit unnecessarily and to fail fast."
    end

    it 'contains the resolution in the message' do
      expect(error.message).to include "Valid options are: valid, make sure these are the ones you are using"
    end
  end
end # Github::Error::InvalidOptions
