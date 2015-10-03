# encoding: utf-8

require 'spec_helper'

describe Github::Client::Orgs::Members, '#grant_organization_membership' do
  let(:org) { 'CodeCu' }
  let(:status) { 200 }

  before {
    stub_put(request_path).to_return(:body => body, :status => status,
                                     :headers => {:content_type => "application/json; charset=utf-8"})
  }


  context 'Add/update organization membership - unaffiliated user' do
    
    let(:username) { 'anujaware' }
    let(:request_path) { "/orgs/#{org}/memberships/#{username}" }
    let(:body) { fixture('orgs/membership_to_unaffiliated_user.json') }
    
    it 'should create organization membership with pending state' do
      response = subject.grant_organization_membership org, username, {role: 'member'}
      response.state.should == 'pending'
    end

    it 'should create organization membership with role member' do
      response = subject.grant_organization_membership org, username, {role: 'member'}
      response.role.should == 'member'
    end
  end

  context 'Add/update organization membership - affiliated user' do
    
    let(:username) { 'anuja-joshi' }
    let(:request_path) { "/orgs/#{org}/memberships/#{username}" }
    let(:body) { fixture('orgs/membership_to_affilliated_user.json') }
    
    it 'should create organization membership with active state' do
      response = subject.grant_organization_membership org, username, {role: 'admin'}
      response.state.should == 'active'
    end

    it 'should update organization membership with role admin' do
      response = subject.grant_organization_membership org, username, {role: 'admin'}
      response.role.should == 'admin'
    end
  end
end # grant_organization_membership
