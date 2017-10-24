# encoding: utf-8

require 'spec_helper'

describe Github::Client::Search::Legacy, '#users' do
  let(:keyword)      { 'api' }
  let(:request_path) { "/legacy/user/search/#{keyword}" }

  before do
    stub_get(request_path).
      to_return(body: body, status: status,
        headers: {content_type: "application/json; charset=utf-8"})
  end

  context "resource found" do
    let(:body)   { fixture('search/users_legacy.json') }
    let(:status) { 200 }

    it { expect { subject.users }.to raise_error(ArgumentError) }

    it "should get the resources" do
      subject.users keyword
      a_get(request_path).should have_been_made
    end

    it "should get the resource through params hash" do
      subject.users keyword: keyword
      a_get(request_path).should have_been_made
    end

    it "should get repository information" do
      users = subject.users keyword: keyword
      users.users.first.username.should == 'techno'
    end
  end
end
