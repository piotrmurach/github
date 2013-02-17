# encoding: utf-8

require 'spec_helper'

describe Github::Repos, 'integration' do

  after { reset_authentication_for subject }

  it_should_behave_like 'api interface'

  its(:collaborators) { should be_a Github::Repos::Collaborators }

  its(:comments)      { should be_a Github::Repos::Comments }

  its(:commits)       { should be_a Github::Repos::Commits }

  its(:contents)      { should be_a Github::Repos::Contents }

  its(:downloads)     { should be_a Github::Repos::Downloads }

  its(:forks)         { should be_a Github::Repos::Forks }

  its(:keys)          { should be_a Github::Repos::Keys }

  its(:hooks)         { should be_a Github::Repos::Hooks }

  its(:merging)       { should be_a Github::Repos::Merging }

  its(:statuses)      { should be_a Github::Repos::Statuses }

  its(:pubsubhubbub)  { should be_a Github::Repos::PubSubHubbub }

end # Github::Repos
