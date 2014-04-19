# encoding: utf-8

require 'spec_helper'

describe Github::Client::Orgs, 'integration' do

  after { reset_authentication_for subject }

  it_should_behave_like 'api interface'

  its(:members) { should be_a Github::Client::Orgs::Members }

  its(:teams)   { should be_a Github::Client::Orgs::Teams }

end # Github::Client::Orgs
