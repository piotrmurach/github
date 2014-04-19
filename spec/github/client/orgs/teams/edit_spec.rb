# encoding: utf-8

require 'spec_helper'

describe Github::Client::Orgs::Teams, '#edit' do
  let(:team)   { 'github' }
  let(:request_path) { "/teams/#{team}" }

  let(:inputs) {
    { :name => 'new team',
      :permissions => 'push',
    }
  }

  before {
    stub_patch(request_path).with(inputs).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resouce edited" do
    let(:body) { fixture('orgs/team.json') }
    let(:status) { 200 }

    it "should fail to create resource if 'team name' param is missing" do
      expect { subject.edit }.to raise_error(ArgumentError)
    end

    it "should failt to create resource if 'name' input is missing" do
      expect {
        subject.edit team, inputs.except(:name)
      }.to raise_error(Github::Error::RequiredParams)
    end

    it "should create resource successfully" do
      subject.edit team, inputs
      a_patch(request_path).with(inputs).should have_been_made
    end

    it "should return the resource" do
      edited_team = subject.edit team, inputs
      edited_team.should be_a Github::ResponseWrapper
    end

    it "should get the team information" do
      edited_team = subject.edit team, inputs
      edited_team.name.should == 'Owners'
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.edit team, inputs }
  end

end # edit
