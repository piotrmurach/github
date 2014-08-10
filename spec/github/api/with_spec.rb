# encoding: utf-8

require 'spec_helper'

describe Github::API, '#with' do
  let(:user) { 'peter-murach' }

  after { reset_authentication_for subject }

  context 'with hash' do
    it 'supports list of options' do
      subject.with(user: user, repo: 'github')
      subject.user.should == user
    end
  end

  context 'with string' do
    it 'support forward slash delimiter options' do
      subject.with('peter-murach/github')
      subject.user.should == user
    end

    it 'fails without slash delimiter' do
      expect { subject.with('peter-murach') }.to raise_error(ArgumentError)
    end
  end
end
