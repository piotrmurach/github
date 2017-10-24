require 'spec_helper'

describe Github::Client::GitData, 'integration' do

  after { reset_authentication_for subject }

  it_should_behave_like 'api interface'

  its(:blobs)      { should be_a Github::Client::GitData::Blobs }

  its(:commits)    { should be_a Github::Client::GitData::Commits }

  its(:references) { should be_a Github::Client::GitData::References }

  its(:tags)       { should be_a Github::Client::GitData::Tags }

  its(:trees)      { should be_a Github::Client::GitData::Trees }

end # Github::GitData
