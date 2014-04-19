# encoding: utf-8

require 'spec_helper'

describe Github::Client::Gitignore, '#list' do
  let(:request_path) { "/gitignore/templates" }

  before {
    stub_get(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found" do
    let(:body) { fixture("gitignore/templates.json") }
    let(:status) { 200 }

    it { should respond_to :all }

    it "should get the resources" do
      subject.list
      a_get(request_path).should have_been_made
    end

    it "should get template information" do
      templates = subject.list
      templates.first.should == 'Actionscript'
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list { |obj| yielded << obj }
      yielded.should == result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list }
  end
end # list
