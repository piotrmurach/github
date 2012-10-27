# -*- encoding: utf-8 -*-

require 'spec_helper'

describe Github::API, '#set' do

  after { reset_authentication_for subject }

  it 'requires value to be set' do
    expect { subject.set :option }.to raise_error(ArgumentError)
  end

  it 'accepts more than one option' do
    subject.set :user => 'user-name', :repo => 'repo-name'
    subject.user.should == 'user-name'
    subject.repo.should == 'repo-name'
  end

end
