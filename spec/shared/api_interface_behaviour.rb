# encoding: utf-8

shared_examples_for 'api interface' do

  it { should respond_to :endpoint }

  it { should respond_to :site }

  it { should respond_to :user }

  it { should respond_to :repo }

  it { should respond_to :adapter }

end
