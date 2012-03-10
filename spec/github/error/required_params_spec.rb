# encoding: utf-8

require 'spec_helper'

describe Github::Error::RequiredParams do
  describe '#message' do
    let(:error) { described_class.new({:extra => true}, [:required]) }

    it 'contains the problem in the message' do
      error.message.should include "Missing required parameters: extra provided for this request."
    end

    it 'contains the summary in the message' do
      error.message.should include "Github gem checks the request parameters passed to ensure that github api is not hit unnecessairly and to fail fast."
    end

    it 'contains the resolution in the message' do
      error.message.should include "Required parameters are: required, make sure these are the ones you are using"
    end
  end
end # Github::Error::RequiredParams
