# encoding: utf-8

require "spec_helper"

RSpec.describe Github::Client::PullRequests::Reviews do
  after { reset_authentication_for subject }

  it_should_behave_like "api interface"
end # Github::Client::PullRequests::Reviews
