# encoding: utf-8

require 'spec_helper'

describe Github::Client::GitData::References do

  it { described_class::VALID_REF_PARAM_NAMES.should_not be_nil }

  it { described_class::VALID_REF_PARAM_VALUES.should_not be_nil }

end # Github::GitData::References
