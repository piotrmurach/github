# encoding: utf-8

require 'spec_helper'

describe Github::Client::Users, 'integration' do

  after { reset_authentication_for subject }

  it_should_behave_like 'api interface'

  its(:emails)    { should be_a Github::Client::Users::Emails }

  its(:followers) { should be_a Github::Client::Users::Followers }

  its(:keys)      { should be_a Github::Client::Users::Keys }
end
