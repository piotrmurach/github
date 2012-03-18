require 'spec_helper'

describe Github::GitData do

  context 'access to apis' do
    it { subject.blobs.should be_a Github::GitData::Blobs }
    it { subject.commits.should be_a Github::GitData::Commits }
    it { subject.references.should be_a Github::GitData::References }
    it { subject.tags.should be_a Github::GitData::Tags }
    it { subject.trees.should be_a Github::GitData::Trees }
  end

end # Github::GitData
