# encoding: utf-8

require 'spec_helper'

describe Github::Validations::Token do

  let(:validator) { Class.new.extend(described_class) }

  context '#validates_token_for' do
    it 'does not require authentication token' do
      validator.validates_token_for(:get, '/octocat/emails').should be_false
    end

    it 'requires authentication token' do
      validator.validates_token_for(:get, '/user/emails').should be_true
    end
  end

end # Github::Validations::Token
