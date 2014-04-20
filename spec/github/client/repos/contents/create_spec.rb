# encoding: utf-8

require 'spec_helper'

describe Github::Client::Repos::Contents, '#create' do
  let(:user) { 'peter-murach' }
  let(:repo) { 'github' }
  let(:path) { 'hello.rb' }
  let(:request_path) { "/repos/#{user}/#{repo}/contents/#{path}" }

  before {
    stub_put(request_path).to_return(:body => body, :status => status,
        :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  let(:params) {
    {
      "path"    => 'hello.rb',
      "content" => "puts 'hello ruby'",
      "message" => "initial commit"
    }
  }
  let(:body) { fixture('repos/content_created.json') }
  let(:status) { 201 }

  it { expect { subject.create }.to raise_error(ArgumentError)}

  it { expect { subject.create user, repo, path }.to raise_error(Github::Error::RequiredParams) }

  it "creates the resource" do
    subject.create user, repo, path, params
    a_put(request_path).should have_been_made
  end

  it "gets repository contents information" do
    content = subject.create user, repo, path, params
    content.content.name.should == 'hello.txt'
  end
end
