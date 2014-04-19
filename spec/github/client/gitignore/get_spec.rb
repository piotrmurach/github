# encoding: utf-8

require 'spec_helper'

describe Github::Client::Gitignore, '#get' do
  let(:template) { 'Ruby' }
  let(:request_path) { "/gitignore/templates/#{template}" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:accept => accept })
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture("gitignore/template.json") }
    let(:status) { 200 }
    let(:accept) { "application/json; charset=utf-8" }

    it { should respond_to :find }

    it "should fail to get resource without key" do
      expect { subject.get }.to raise_error(ArgumentError)
    end

    it "should get the resource" do
      subject.get template
      a_get(request_path).should have_been_made
    end

    it "should get key information" do
      temp = subject.get template
      temp.name.should == "C"
    end
  end

  context 'raw content' do
    let(:body) { fixture("gitignore/template_raw") }
    let(:status) { 200 }
    let(:accept) { 'application/vnd.github.raw' }

    it "should get the resource" do
      subject.get template, 'accept' => 'application/vnd.github.raw'
      a_get(request_path).should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:accept) { 'application/json' }
    let(:requestable) { subject.get template }
  end
end # get
