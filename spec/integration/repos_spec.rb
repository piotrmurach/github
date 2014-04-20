# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos, 'integration' do

  after { reset_authentication_for subject }

  it_should_behave_like 'api interface'

  its(:collaborators) { should be_a Github::Client::Repos::Collaborators }

  its(:comments)      { should be_a Github::Client::Repos::Comments }

  its(:commits)       { should be_a Github::Client::Repos::Commits }

  its(:contents)      { should be_a Github::Client::Repos::Contents }

  its(:downloads)     { should be_a Github::Client::Repos::Downloads }

  its(:forks)         { should be_a Github::Client::Repos::Forks }

  its(:keys)          { should be_a Github::Client::Repos::Keys }

  its(:hooks)         { should be_a Github::Client::Repos::Hooks }

  its(:merging)       { should be_a Github::Client::Repos::Merging }

  its(:statuses)      { should be_a Github::Client::Repos::Statuses }

  its(:releases)      { should be_a Github::Client::Repos::Releases }

  its(:stats)         { should be_a Github::Client::Repos::Statistics }

  its(:pubsubhubbub)  { should be_a Github::Client::Repos::PubSubHubbub }

end # Github::Repos
