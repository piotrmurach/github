require 'spec_helper'

describe Github::GitData, 'integration' do

  after { reset_authentication_for subject }

  it_should_behave_like 'api interface'

  its(:blobs)      { should be_a Github::GitData::Blobs }

  its(:commits)    { should be_a Github::GitData::Commits }

  its(:references) { should be_a Github::GitData::References }

  its(:tags)       { should be_a Github::GitData::Tags }

  its(:trees)      { should be_a Github::GitData::Trees }

end # Github::GitData
