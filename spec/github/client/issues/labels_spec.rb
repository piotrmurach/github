# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Labels, 'integration' do

  it { described_class::VALID_LABEL_INPUTS.should_not be_nil }

end # Github::Client::Issues::Labels
