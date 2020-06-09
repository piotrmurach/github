# encoding: utf-8

require 'spec_helper'

describe Github::Client::GitData::Blobs do

  it { expect(described_class::VALID_BLOB_PARAM_NAMES).to_not be_nil }

end # Github::GitData::Blobs
