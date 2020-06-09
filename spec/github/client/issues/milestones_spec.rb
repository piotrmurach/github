# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Milestones do

  it { expect(described_class::VALID_MILESTONE_OPTIONS).to_not be_nil }

  it { expect(described_class::VALID_MILESTONE_INPUTS).to_not be_nil }

end # Github::Issues::Milestones
