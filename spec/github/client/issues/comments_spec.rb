# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues::Comments do

  it { expect(described_class::VALID_ISSUE_COMMENT_PARAM_NAME).to_not be_nil }

end # Github::Issues::Comments
