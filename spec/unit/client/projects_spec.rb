# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Projects do
  let(:object) { described_class }

  subject(:client) { object.new }

  it { expect(client.columns).to be_a Github::Client::Projects::Columns }

  it { expect(client.cards).to be_a Github::Client::Projects::Cards }
end
