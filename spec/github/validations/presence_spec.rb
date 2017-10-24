# encoding: utf-8

require 'spec_helper'

describe Github::Validations::Presence do

  let(:validator) { Class.new.extend(described_class) }

  context '#assert_presence_of' do
    it 'checks hash with nil value' do
      user, repo = nil, 'github_api'
      expect {
        validator.assert_presence_of user, repo
      }.to raise_error(ArgumentError)
    end

    it 'asserts array without nil value' do
      user, repo = 'peter-murach', 'github_api'
      expect { validator.assert_presence_of user, repo }.to_not raise_error()
    end

    it 'assert hash with nil value' do
      args = {:user => nil, :repo => 'github_api'}
      expect { validator.assert_presence_of args }.
        to raise_error(Github::Error::Validations)
    end

    it 'asserts hash without nil value' do
      args = {:user => 'peter-murach', :repo => 'github_api'}
      expect { validator.assert_presence_of args }.to_not raise_error()
    end
  end

end # Github::Validations::Presence
