# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Gists, '#list' do
  let(:user) { 'peter-murach' }
  let(:body) { fixture('gists/gists.json') }
  let(:status) { 200 }

  before {
    stub_get(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "when unauthenticated user" do
    let(:request_path) { "/users/#{user}/gists" }

    context "resource found" do
      it { is_expected.to respond_to :all }

      it "gets the resources" do
        subject.list(user: user)
        expect(a_get(request_path)).to have_been_made
      end

      it_should_behave_like 'an array of resources' do
        let(:requestable) { subject.list :user => user }
      end

      it "gets gist information" do
        gists = subject.list(user: user)
        expect(gists.first.user.login).to eq('octocat')
      end

      it "yields to a block" do
        yielded = []
        result = subject.list(user: user) { |obj| yielded << obj }
        expect(yielded).to eq(result)
      end
    end

    it_should_behave_like 'request failure' do
      let(:requestable) { subject.list :user => user }
    end
  end # unauthenticated user

  context 'when public' do
    let(:request_path) { "/gists/public" }

    it "gets the resources" do
      subject.list(:public)
      expect(a_get(request_path)).to have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list :public }
    end
  end

  context 'when authenticated user' do
    let(:request_path) { "/gists" }

    before do
      subject.oauth_token = OAUTH_TOKEN
      stub_get(request_path).with(:query => {:access_token => OAUTH_TOKEN}).
        to_return(:body => fixture('gists/gists.json'), :status => 200,
        :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "gets the resources" do
      subject.list
      expect(a_get(request_path).with(:query => {:access_token => OAUTH_TOKEN})).
        to have_been_made
    end
  end
end # list
