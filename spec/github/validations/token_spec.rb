# encoding: utf-8

require 'spec_helper'

describe Github::Validations::Token do

  let(:validator) { Class.new.extend(described_class) }

  context '#validates_token_for' do
    it 'does not require authentication token' do
      expect(validator.validates_token_for(:get, '/octocat/emails')).to be false
    end

    it 'requires authentication token' do
      expect(validator.validates_token_for(:get, '/user/emails')).to be true
    end
  end

end # Github::Validations::Token
