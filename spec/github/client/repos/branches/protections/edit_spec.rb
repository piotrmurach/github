# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Branches::Protections, '#edit' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:branch) { 'master' }
  let(:request_path) { "/repos/#{user}/#{repo}/branches/#{branch}/protection" }
  let(:inputs) do
    { 
      :required_status_checks => nil,
      :required_pull_request_reviews => {dismiss_stale_reviews: false},
      :enforce_admins => nil,
      :restrictions => nil
    }
  end

  before {
    stub_put(request_path).with(body: inputs).
    to_return(:status => status, :body => body, :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resource edited successfully" do
    let(:body)  { fixture("repos/protection.json") }
    let(:status) { 200 }

    it "should fail to edit without 'user/repo' parameters" do
      expect { subject.edit user, nil, branch }.to raise_error(ArgumentError)
    end

    # it "should fail to edit resource without 'name' parameter" do
    #   expect{
    #     subject.edit user, repo, branch, inputs.except(:name)
    #   }.to raise_error(Github::Error::RequiredParams)
    # end

    it "should edit the resource" do
      subject.edit user, repo, branch, inputs
      expect(a_put(request_path).with(body: inputs)).to have_been_made
    end

    it "should return resource" do
      repository = subject.edit user, repo, branch, inputs
      expect(repository).to be_a Github::ResponseWrapper
    end

    it "is_expected.to be able to retrieve information" do
      protection = subject.edit user, repo, branch, inputs
      expect(protection.required_pull_request_reviews.dismiss_stale_reviews).to eq false
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.edit user, repo, branch, inputs }
  end
end # edit
