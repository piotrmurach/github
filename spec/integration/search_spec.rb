# encoding: utf-8

require 'spec_helper'

describe Github::Client::Search, 'integration' do

  after { reset_authentication_for subject }

  it_should_behave_like 'api interface'

  its(:legacy) { should be_a Github::Client::Search::Legacy }
end
