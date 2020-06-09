# encoding: utf-8

require 'spec_helper'

describe Github::Client::Users, 'integration' do

  after { reset_authentication_for subject }

  it_should_behave_like 'api interface'

  its(:emails)    { is_expected.to be_a Github::Client::Users::Emails }

  its(:followers) { is_expected.to be_a Github::Client::Users::Followers }

  its(:keys)      { is_expected.to be_a Github::Client::Users::Keys }
end
