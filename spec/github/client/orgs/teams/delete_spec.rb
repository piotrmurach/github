# encoding: utf-8

require 'spec_helper'

describe Github::Client::Orgs::Teams, '#delete' do
  let(:team_id)   { 1 }
  let(:request_path) { "/teams/#{team_id}" }

  before {
    stub_delete(request_path).to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource deleted successfully" do
    let(:body) { '' }
    let(:status) { 204 }

    it { should respond_to :remove }

    it "should fail to delete without 'team_id' parameter" do
      expect { subject.delete }.to raise_error(ArgumentError)
    end

    it "should delete the resource" do
      subject.delete team_id
      a_delete(request_path).should have_been_made
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.delete team_id }
  end
end # delete
