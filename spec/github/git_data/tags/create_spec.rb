# encoding: utf-8

require 'spec_helper'

describe Github::Client::GitData::Tags, '#create' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:sha) { "940bd336248efae0f9ee5bc7b2d5c985887b16ac" }
  let(:request_path) { "/repos/#{user}/#{repo}/git/tags" }

  before {
    stub_post(request_path).with(inputs.except('unrelated')).
      to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for subject }

  let(:inputs) {
    {
      "tag" => "v0.0.1",
      "message" => "initial version\n",
        "object" => {
          "type" => "commit",
          "sha" => "c3d0be41ecbe669545ee3e94d31ed9a4bc91ee3c",
          "url" => "https://api.github.com/repos/octocat/Hello-World/git/commits/c3d0be41ecbe669545ee3e94d31ed9a4bc91ee3c"
        },
      "tagger" => {
        "name" => "Scott Chacon",
        "email" => "schacon@gmail.com",
        "date" => "2011-06-17T14:53:35-07:00"
      },
      'unrelated' => 'giberrish'
    }
  }

  context "resouce created" do
    let(:body) { fixture('git_data/tag.json') }
    let(:status) { 201 }

    it { expect { subject.create user }.to raise_error(ArgumentError) }

    it "should create resource successfully" do
      subject.create user, repo, inputs
      a_post(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      tag = subject.create user, repo, inputs
      tag.should be_a Github::ResponseWrapper
    end

    it "should get the tag information" do
      tag = subject.create user, repo, inputs
      tag.sha.should == sha
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create user, repo, inputs }
  end

end # create
