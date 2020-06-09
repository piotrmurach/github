# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues do

  after { reset_authentication_for subject }

  it_should_behave_like 'api interface'

  its(:assignees)  { is_expected.to be_a Github::Client::Issues::Assignees }

  its(:comments)   { is_expected.to be_a Github::Client::Issues::Comments }

  its(:events)     { is_expected.to be_a Github::Client::Issues::Events }

  its(:labels)     { is_expected.to be_a Github::Client::Issues::Labels }

  its(:milestones) { is_expected.to be_a Github::Client::Issues::Milestones }

end # Github::Issues
