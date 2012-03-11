# encoding: utf-8

require 'spec_helper'

describe Github do
  let(:method) { 'create_repos'}
  let(:alt_method) { 'repos.create'}

  it { described_class.constants.should include :DEPRECATION_PREFIX }

  context '.deprecate' do
    before do
      Github.deprecation_tracker = []
    end

    it 'tracks messages' do
      Github.should_receive(:warn).once()
      Github.deprecate(method)
      Github.deprecate(method)
    end

    it 'prints the message through Kernel' do
      Github.should_receive(:warn).once()
      Github.deprecate method
    end
  end

  it 'prints the message through Kernel' do
    Github.should_receive(:warn)
    Github.warn_deprecation method
  end
end # Github
