# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Milestones do

  it { described_class::VALID_MILESTONE_OPTIONS.should_not be_nil }

  it { described_class::VALID_MILESTONE_INPUTS.should_not be_nil }

end # Github::Issues::Milestones
