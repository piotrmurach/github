# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Downloads do

  after { reset_authentication_for(subject) }

  it { expect(described_class::VALID_DOWNLOAD_PARAM_NAMES).to_not be_nil }

  it { expect(described_class::REQUIRED_PARAMS).to_not be_nil }

end # Github::Client::Repos::Downloads
