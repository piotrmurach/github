# encoding: utf-8

require 'spec_helper'

describe Github::Client::Gists, '#edit' do
  let(:gist_id) { 1 }
  let(:request_path) { "/gists/#{gist_id}" }

  let(:inputs) {
    {
      "description" => "the description for this gist",
      "files" => {
        "file1.txt" => {
          "content" => "updated file contents"
        },
        "old_name.txt" => {
          "filename" => "new_name.txt",
          "content" => "modified contents"
        },
        "new_file.txt" => {
          "content" => "a new file"
        },
        "delete_this_file.txt" => nil
      }
    }
  }

  before {
    stub_patch(request_path).with(inputs).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce edited" do
    let(:body) { fixture('gists/gist.json') }
    let(:status) { 200 }

    it "should edit resource successfully" do
      subject.edit gist_id, inputs
      a_patch(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      gist = subject.edit gist_id, inputs
      gist.should be_a Github::ResponseWrapper
    end

    it "should get the gist information" do
      gist = subject.edit gist_id, inputs
      gist.user.login.should == 'octocat'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.edit gist_id, inputs }
  end

end # edit
