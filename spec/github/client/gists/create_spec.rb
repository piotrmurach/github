# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Gists, '#create' do
  let(:request_path) { "/gists" }

  let(:inputs) {
    {
      "description" => "the description for this gist",
      "public" => true,
      "files" => {
        "file1.txt" => {
          "content" => "String file contents"
        }
      },
    }
  }

  before {
    stub_post(request_path).with(body: inputs).
      to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce created" do
    let(:body) { fixture('gists/gist.json') }
    let(:status) { 201 }

    it "creates resource successfully" do
      subject.create inputs
      expect(a_post(request_path).with(body: inputs)).to have_been_made
    end

    it "returns the resource" do
      gist = subject.create inputs
      expect(gist).to be_a Github::ResponseWrapper
    end

    it "gets the gist information" do
      gist = subject.create inputs
      expect(gist.user.login).to eq('octocat')
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.create inputs }
  end
end # create
