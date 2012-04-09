# encoding: utf-8

require 'spec_helper'

describe Github::PagedRequest do
  it { described_class.constants.should include :FIRST_PAGE }
  it { described_class.constants.should include :PER_PAGE }
  it { described_class.constants.should include :NOT_FOUND }

  context 'page_request' do
    let(:path) { '/repos' }
    let(:client) { Github::Client }

    before do
      Github.stub(:api_client).and_return client
      client.stub(:get_request)
    end

    it 'sets default per_page when only custom page passed' do
      Github.stub_chain(:api_client, :per_page).and_return nil
      Github::PagedRequest.page_request path, {'page' => 3, 'per_page' => -1}
      Github::PagedRequest.page.should eq 3
      Github::PagedRequest.per_page.should eq 30
    end

    it 'sets default page when only custom per_page passed' do
      Github.stub_chain(:api_client, :page).and_return nil
      Github::PagedRequest.page_request path, {'per_page' => 33, 'page' => -1}
      Github::PagedRequest.page.should eq 1
      Github::PagedRequest.per_page.should eq 33
    end

    it 'sends get request with passed parameters' do
      Github::Client.should_receive(:get_request).
        with(path, 'page' => 2, 'per_page' => 33)
      Github::PagedRequest.page_request path, {'page' => 2, 'per_page' => 33}
    end
  end

end # Github::PagedRequest
