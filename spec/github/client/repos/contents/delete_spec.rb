# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Contents, '#delete' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:path) { 'hello.rb' }
  let(:params) {
    {
      "path"    => 'hello.rb',
      "message" => "initial commit",
      "sha"     => "329688480d39049927147c162b9d2deaf885005f"
    }
  }
  let(:request_path) { "/repos/#{user}/#{repo}/contents/#{path}" }

  after { reset_authentication_for(subject) }

  before do
    stub_delete(request_path).with(:query => params).
      to_return(:body => body, :status => status,
        :headers => { :content_type => "application/json; charset=utf-8"})
  end

  context "resource deleted successfully" do
    let(:body)   { fixture('repos/content_deleted.json') }
    let(:status) { 200 }

    it { expect { subject.delete }.to raise_error(ArgumentError) }

    it "should fail to delete without 'user/repo' parameters" do
      expect { subject.delete user }.to raise_error(ArgumentError)
    end

    it "should fail to delete resource without 'path'" do
      expect { subject.delete user, repo, path }.to raise_error(Github::Error::RequiredParams)
    end

    it "should delete the resource" do
      subject.delete user, repo, path, params
      a_delete(request_path).with(:query => params).should have_been_made
    end

    it "gets repository contents information" do
      content = subject.delete user, repo, path, params
      content.content.should be_nil
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.delete user, repo, path, params }
  end

end # delete
