# encoding: utf-8

require 'spec_helper'

describe Github::Error::UnknownValue do
  describe '#message' do
    let(:error) { described_class.new(:state, 'open', "closed, deleted") }

    it 'contains the problem in the message' do
      error.message.should include "Wrong value of 'open' for the parameter: state provided for this request"
    end

    it 'contains the summary in the message' do
      error.message.should include "Github gem checks the request parameters passed to ensure that github api is not hit unnecessairly and fails fast."
    end

    it 'contains the resolution in the message' do
      error.message.should include "Permitted values are: closed, deleted, make sure these are the ones you are using"
    end
  end
end # Github::Error::UnkownValue
