# encoding: utf-8

require 'spec_helper'

describe Github::Validations::Format do

  let(:validator) { Class.new.extend(described_class) }

  context '#_validate_params_values' do
    let(:permitted) {
      {
        'param_a' => ['a', 'b'],
        'param_b' => /^github$/
      }
    }

    it 'fails to accept unkown value for a given parameter key' do
      actual = { 'param_a' => 'x' }
      expect {
        validator._validate_params_values(permitted, actual)
      }.to raise_error(Github::Error::UnknownValue)
    end

    it 'accepts known value for a given parameter key' do
      actual = { 'param_a' => 'a'}
      validator._validate_params_values(permitted, actual)
    end

    it 'fails to match regex value for a given parameter key' do
      actual = { 'param_b' => 'xgithub' }
      expect {
        validator._validate_params_values(permitted, actual)
      }.to raise_error(Github::Error::UnknownValue)
    end

    it 'matches regex value for a given parameter key' do
      actual = { 'param_b' => 'github'}
      validator._validate_params_values(permitted, actual)
    end
  end

end # Github::Validations::Format
