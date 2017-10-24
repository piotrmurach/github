# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Downloads do

  after { reset_authentication_for(subject) }

  it { described_class::VALID_DOWNLOAD_PARAM_NAMES.should_not be_nil }

  it { described_class::REQUIRED_PARAMS.should_not be_nil }

end # Github::Client::Repos::Downloads
