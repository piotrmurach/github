# encoding: utf-8

require 'spec_helper'

describe Github::Error::InvalidOptions do
  describe '#message' do
    let(:error) { described_class.new({:invalid => true}, [:valid]) }

    it 'contains the problem in the message' do
      error.message.should include "Invalid option invalid provided for this request."
    end

    it 'contains the summary in the message' do
      error.message.should include "Github gem checks the request parameters passed to ensure that github api is not hit unnecessairly and to fail fast."
    end

    it 'contains the resolution in the message' do
      error.message.should include "Valid options are: valid, make sure these are the ones you are using"
    end
  end
end # Github::Error::InvalidOptions
