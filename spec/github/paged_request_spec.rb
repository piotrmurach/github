# encoding: utf-8

require 'spec_helper'
require 'github_api/paged_request'

describe Github::PagedRequest, '#page_request' do
  let(:current_api) { Github::Client::Repos.new }
  let(:path) { "/repositories/"}
  let(:klass) {
    Class.new do
      include Github::PagedRequest
    end
  }

  subject(:instance) { klass.new }

  before {
    allow(instance).to receive(:current_api).and_return current_api
  }

  it { expect(klass.constants).to include :FIRST_PAGE }

  it { expect(klass.constants).to include :PER_PAGE }

  it { expect(klass.constants).to include :NOT_FOUND }

  it { is_expected.to respond_to(:page_request) }

  it 'calls get_request on api current instance' do
    expect(current_api).to receive(:get_request).with(path, {})
    instance.page_request(path)
  end

  it 'sets default per_page when only custom page passed' do
    expect(current_api).to receive(:get_request).
      with(path, {'page' => 3, 'per_page' => 30})
    instance.page_request(path, {'page' => 3, 'per_page' => -1})
  end

  it 'sets default page when only custom per_page passed' do
    expect(current_api).to receive(:get_request).
      with(path, {'page' => 1, 'per_page' => 33})
    instance.page_request(path, {'page' => -1, 'per_page' => 33})
  end

end # Github::PagedRequest
