# encoding: utf-8

require 'spec_helper'
require 'github_api/core_ext/hash'

describe Github::Validations::Required do

  let(:validator) {
    klaz = Class.new.extend(described_class)
  }

  context '#assert_required_keys' do
    let(:required) { ['param_a', 'param_c'] }
    let(:provided) { { 'param_a' => true, 'param_c' => true } }

    it 'detect missing parameter' do
      expect {
        validator.assert_required_keys(required, provided.except('param_c')).
          should be_false
      }.to raise_error(Github::Error::RequiredParams)
    end

    it 'asserts correct required parameters' do
      validator.assert_required_keys(required, provided).should be_true
    end
  end

end # Github::Validations::Required
