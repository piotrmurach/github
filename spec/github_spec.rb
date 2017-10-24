# encoding: utf-8

require 'spec_helper'

describe Github do
  after { reset_authentication_for subject }

  it { should respond_to :new }

  it { expect(subject.new).to be_a Github::Client }

end # Github
