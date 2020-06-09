# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Authorizations, '#list' do
  let(:basic_auth) { 'login:password' }
  let(:request_path) { "/authorizations" }
  let(:host) { "https://api.github.com" }

  subject { described_class.new(basic_auth: basic_auth) }

  before do
    stub_get(request_path, host).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  end

  context "resource found" do
    let(:body) { fixture('auths/authorizations.json') }
    let(:status) { 200 }

    it { is_expected.to respond_to :all }

    it "should fail to get resource without basic authentication" do
      reset_authentication_for subject
      expect { subject.list }.to raise_error(ArgumentError)
    end

    it "should get the resources" do
      subject.list
      expect(a_get(request_path, host)).to have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list }
    end

    it "should get authorization information" do
      authorizations = subject.list
      expect(authorizations.first.token).to eq 'abc123'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list { |obj| yielded << obj }
      expect(yielded).to eq result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list }
  end
end # authorizations
