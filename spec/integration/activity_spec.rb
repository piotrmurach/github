# encoding: utf-8

require 'spec_helper'

describe Github::Client::Activity, 'integration' do

  after { reset_authentication_for subject }

  it_should_behave_like 'api interface'

  its(:events)        { should be_a Github::Client::Activity::Events }

  its(:notifications) { should be_a Github::Client::Activity::Notifications }

  its(:starring)      { should be_a Github::Client::Activity::Starring }

  its(:watching)      { should be_a Github::Client::Activity::Watching }
end
