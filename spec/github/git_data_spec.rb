require 'spec_helper'

describe Github::GitData do

  its(:blobs)   { should be_a Github::GitData::Blobs }
  its(:commits) { should be_a Github::GitData::Commits }
  its(:references) { should be_a Github::GitData::References }
  its(:tags)  { should be_a Github::GitData::Tags }
  its(:trees) { should be_a Github::GitData::Trees }

end # Github::GitData
