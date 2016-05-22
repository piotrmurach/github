# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Gists, '#edit' do
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
      to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce edited" do
    let(:body) { fixture('gists/gist.json') }
    let(:status) { 200 }

    it "edits resource successfully" do
      subject.edit(gist_id, inputs)
      expect(a_patch(request_path).with(inputs)).to have_been_made
    end

    it "returns the resource" do
      gist = subject.edit(gist_id, inputs)
      expect(gist).to be_a(Github::ResponseWrapper)
    end

    it "gets the gist information" do
      gist = subject.edit gist_id, inputs
      expect(gist.user.login).to eq('octocat')
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.edit gist_id, inputs }
  end
end # edit
