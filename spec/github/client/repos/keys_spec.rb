# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Keys do
  it_should_behave_like 'api interface'

  it { described_class::VALID_KEY_OPTIONS.should_not be_nil }
end # Github::Repos::Keys
