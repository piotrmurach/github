# encoding: utf-8

require 'spec_helper'

describe Github::Client::GitData::Commits do

  it { described_class::VALID_COMMIT_PARAM_NAMES.should_not be_nil }

end # Github::GitData::Commits
