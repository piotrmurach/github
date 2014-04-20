# encoding: utf-8

require 'spec_helper'

describe Github::PagedRequest, '#page_request' do
  let(:current_api) { Github::Client::Repos.new }
  let(:path) { "/repositories/"}
  let(:klass) {
    klass = Class.new do
      include Github::PagedRequest
    end
  }

  subject(:instance) { klass.new }

  before {
    instance.stub(:current_api).and_return current_api
  }

  it { klass.constants.should include :FIRST_PAGE }

  it { klass.constants.should include :PER_PAGE }

  it { klass.constants.should include :NOT_FOUND }

  it { should respond_to(:page_request) }

  it 'calls get_request on api current instance' do
    current_api.should_receive(:get_request).with(path, {})
    instance.page_request(path)
  end

  it 'sets default per_page when only custom page passed' do
    current_api.should_receive(:get_request).
      with(path, {'page' => 3, 'per_page' => 30})
    instance.page_request(path, {'page' => 3, 'per_page' => -1})
  end

  it 'sets default page when only custom per_page passed' do
    current_api.should_receive(:get_request).
      with(path, {'page' => 1, 'per_page' => 33})
    instance.page_request(path, {'page' => -1, 'per_page' => 33})
  end

end # Github::PagedRequest
