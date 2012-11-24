# encoding: utf-8

require 'spec_helper'

describe Github::Repos::Statuses do

  it { described_class::VALID_STATUS_PARAM_NAMES.should_not be_nil }

  it { described_class::REQUIRED_PARAMS.should_not be_nil }

end # Github::Repos::Statuses
