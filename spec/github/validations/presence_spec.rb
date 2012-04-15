# encoding: utf-8

require 'spec_helper'

describe Github::Validations::Presence do

  let(:validator) { Class.new.extend(described_class) }

  context '#_validate_presence_of' do
    it 'throws error if passed param is nil' do
      gist_id = nil
      expect {
        validator._validate_presence_of gist_id
      }.to raise_error(ArgumentError)
    end
  end

end # Github::Validations::Presence
