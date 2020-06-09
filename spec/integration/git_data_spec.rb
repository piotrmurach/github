require 'spec_helper'

describe Github::Client::GitData, 'integration' do

  after { reset_authentication_for subject }

  it_should_behave_like 'api interface'

  its(:blobs)      { is_expected.to be_a Github::Client::GitData::Blobs }

  its(:commits)    { is_expected.to be_a Github::Client::GitData::Commits }

  its(:references) { is_expected.to be_a Github::Client::GitData::References }

  its(:tags)       { is_expected.to be_a Github::Client::GitData::Tags }

  its(:trees)      { is_expected.to be_a Github::Client::GitData::Trees }

end # Github::GitData
