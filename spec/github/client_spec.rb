# encoding: utf-8

require 'spec_helper'

describe Github::Client do
  let(:object) { described_class }

  subject(:client) { object.new }

  after { reset_authentication_for client }

  it { expect(client.activity).to be_a Github::Client::Activity }

  it { expect(client.gists).to be_a Github::Client::Gists }

  it { expect(client.git_data).to be_a Github::Client::GitData }

  it { expect(client.issues).to be_a Github::Client::Issues }

  it { expect(client.markdown).to be_a Github::Client::Markdown }

  it { expect(client.meta).to be_a Github::Meta }

  it { expect(client.orgs).to be_a Github::Orgs }

  it { expect(client.pull_requests).to be_a Github::PullRequests }

  it { expect(client.repos).to be_a Github::Repos }

  it { expect(client.users).to be_a Github::Users }

  it { expect(client.oauth).to be_a Github::Authorizations }
end
