# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Hooks do

  it { expect(described_class::VALID_HOOK_PARAM_NAMES).to_not be_nil }

  it { expect(described_class::VALID_HOOK_PARAM_VALUES).to_not be_nil }

  it { expect(described_class::REQUIRED_PARAMS).to_not be_nil }

end # Github::Client::Repos::Hooks
