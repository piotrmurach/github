require 'spec_helper'

describe Github::Repos do
  
  let(:github) { Github.new }
  let(:repo) { mock('object').as_null_object } 

  before do
    github.stub(:repos).and_return(repo)
  end

  context "branches" do

    before do
      @branches = []
      repo.stub(:branches).and_return([])
    end

    it "should raise error when no user" do
      expect {
        Github.new.repos.branches
      }.to raise_error(ArgumentError, /\[user\] parameter cannot be nil/)
    end

    it "should raise error when no repo" do
      expect {
        Github.new(:user => 'peter-murach').repos.branches
      }.to raise_error(ArgumentError, /\[repo\] parameter cannot be nil/)
    end

    it "should list all branches" do
      github.repos.should_receive(:branches).and_return(@branches)
    end
  end
end
