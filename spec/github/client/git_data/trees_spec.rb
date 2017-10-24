# encoding: utf-8

require 'spec_helper'

describe Github::Client::GitData::Trees do

  it { described_class::VALID_TREE_PARAM_NAMES.should_not be_nil }

end # Github::GitData::Trees
