# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos, 'integration' do

  after { reset_authentication_for subject }

  it_should_behave_like 'api interface'

  its(:collaborators) { is_expected.to be_a Github::Client::Repos::Collaborators }

  its(:comments)      { is_expected.to be_a Github::Client::Repos::Comments }

  its(:commits)       { is_expected.to be_a Github::Client::Repos::Commits }

  its(:contents)      { is_expected.to be_a Github::Client::Repos::Contents }

  its(:downloads)     { is_expected.to be_a Github::Client::Repos::Downloads }

  its(:forks)         { is_expected.to be_a Github::Client::Repos::Forks }

  its(:keys)          { is_expected.to be_a Github::Client::Repos::Keys }

  its(:hooks)         { is_expected.to be_a Github::Client::Repos::Hooks }

  its(:merging)       { is_expected.to be_a Github::Client::Repos::Merging }

  its(:statuses)      { is_expected.to be_a Github::Client::Repos::Statuses }

  its(:releases)      { is_expected.to be_a Github::Client::Repos::Releases }

  its(:stats)         { is_expected.to be_a Github::Client::Repos::Statistics }

  its(:pubsubhubbub)  { is_expected.to be_a Github::Client::Repos::PubSubHubbub }

  its(:projects)      { is_expected.to be_a Github::Client::Repos::Projects }
end # Github::Repos
