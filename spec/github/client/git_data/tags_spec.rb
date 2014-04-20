# encoding: utf-8

require 'spec_helper'

describe Github::Client::GitData::Tags do

  it { described_class::VALID_TAG_PARAM_NAMES.should_not be_nil }

end # Github::GitData::Tags
