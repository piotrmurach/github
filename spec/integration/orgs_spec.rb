# encoding: utf-8

require 'spec_helper'

describe Github::Client::Orgs, 'integration' do

  after { reset_authentication_for subject }

  it_should_behave_like 'api interface'

  its(:members) { is_expected.to be_a Github::Client::Orgs::Members }

  its(:teams)   { is_expected.to be_a Github::Client::Orgs::Teams }

  its(:memberships) { is_expected.to be_a(Github::Client::Orgs::Memberships) }

end # Github::Client::Orgs
