require 'spec_helper'

describe Github::Orgs, 'integration' do

  after { reset_authentication_for subject }

  it_should_behave_like 'api interface'

  its(:members) { should be_a Github::Orgs::Members }

  its(:teams)   { should be_a Github::Orgs::Teams }

end # Github::Orgs
