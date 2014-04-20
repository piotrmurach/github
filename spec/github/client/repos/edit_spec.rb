# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos, '#edit' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:request_path) { "/repos/#{user}/#{repo}" }
  let(:inputs) do
    { :name => 'web',
      :description => "This is your first repo",
      :homepage => "https://github.com",
      :private => false,
      :has_issues => true,
      :has_wiki => true }
  end

  before {
    stub_patch(request_path).with(inputs).
      to_return(:body => body, :status => status,
        :headers => { :content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  context "resource edited successfully" do
    let(:body)  { fixture("repos/repo.json") }
    let(:status) { 200 }

    it "should fail to edit without 'user/repo' parameters" do
      expect { subject.edit user, nil }.to raise_error(ArgumentError)
    end

    it "should fail to edit resource without 'name' parameter" do
      expect{
        subject.edit user, repo, inputs.except(:name)
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should edit the resource" do
      subject.edit user, repo, inputs
      a_patch(request_path).with(inputs).should have_been_made
    end

    it "should return resource" do
      repository = subject.edit user, repo, inputs
      repository.should be_a Github::ResponseWrapper
    end

    it "should be able to retrieve information" do
      repository = subject.edit user, repo, inputs
      repository.name.should == 'Hello-World'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.edit user, repo, inputs }
  end
end # edit
