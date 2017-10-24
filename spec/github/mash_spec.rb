# encoding: utf-8

require 'spec_helper'
require 'github_api/mash'

describe Github::Mash do
  it 'suppresses warnings for key/method conflict' do
    expect(Hashie.logger).to_not receive(:warn)
    Github::Mash.new(size: 1)
  end

  it 'inherits from Hashie::Mash' do
    expect(Github::Mash.new(size: 1)).to be_a(::Hashie::Mash)
  end
end
