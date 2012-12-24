require 'spec_helper'

describe Github::Issues::Labels, 'integration' do

  it { described_class::VALID_LABEL_INPUTS.should_not be_nil }

end # Github::Issues::Labels
