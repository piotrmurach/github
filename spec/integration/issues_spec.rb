# encoding: utf-8

require 'spec_helper'

describe Github::Client::Issues do

  after { reset_authentication_for subject }

  it_should_behave_like 'api interface'

  its(:assignees)  { should be_a Github::Client::Issues::Assignees }

  its(:comments)   { should be_a Github::Client::Issues::Comments }

  its(:events)     { should be_a Github::Client::Issues::Events }

  its(:labels)     { should be_a Github::Client::Issues::Labels }

  its(:milestones) { should be_a Github::Client::Issues::Milestones }

end # Github::Issues
