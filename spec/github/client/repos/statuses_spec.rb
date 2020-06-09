# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Statuses do

  it { expect(described_class::VALID_STATUS_PARAM_NAMES).to_not be_nil }

  it { expect(described_class::REQUIRED_PARAMS).to_not be_nil }

end # Github::Client::Repos::Statuses
