# encoding: utf-8

require 'spec_helper'

describe Github::Client::GitData::References do

  it { expect(described_class::VALID_REF_PARAM_NAMES).to_not be_nil }

  it { expect(described_class::VALID_REF_PARAM_VALUES).to_not be_nil }

end # Github::GitData::References
