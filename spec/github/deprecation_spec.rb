# encoding: utf-8

require 'spec_helper'

describe Github do
  let(:method) { 'create_repos'}
  let(:alt_method) { 'repos.create'}

  it { expect(described_class.constants).to include :DEPRECATION_PREFIX }

  context '.deprecate' do
    before do
      Github.deprecation_tracker = []
    end

    it 'tracks messages' do
      expect(Github).to receive(:warn).once()
      Github.deprecate(method)
      Github.deprecate(method)
    end

    it 'prints the message through Kernel' do
      expect(Github).to receive(:warn).once()
      Github.deprecate method
    end
  end

  it 'prints the message through Kernel' do
    expect(Github).to receive(:warn)
    Github.warn_deprecation method
  end
end # Github
