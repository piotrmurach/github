# encoding: utf-8

shared_examples_for 'api interface' do

  it { is_expected.to respond_to :endpoint }

  it { is_expected.to respond_to :site }

  it { is_expected.to respond_to :user }

  it { is_expected.to respond_to :repo }

  it { is_expected.to respond_to :adapter }

end
