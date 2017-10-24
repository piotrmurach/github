# encoding: utf-8

require 'spec_helper'

describe Github::Validations do

  let(:validator) { Class.new.send(:include, described_class) }

  it 'includes parameters presence validations' do
    validator.included_modules.should include Github::Validations::Presence
  end

  it 'includes authentication token validations' do
    validator.included_modules.should include Github::Validations::Token
  end

  it 'includes parameters values format validations' do
    validator.included_modules.should include Github::Validations::Format
  end

  it 'includes required parameters presence validations' do
    validator.included_modules.should include Github::Validations::Required
  end

end # Github::Validations
