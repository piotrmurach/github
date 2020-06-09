# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Client::Projects::Columns, '#create' do
  let(:project_id) { 120 }
  let(:inputs) do
    { name: 'To Do' }
  end

  before do
    subject.oauth_token = OAUTH_TOKEN
    stub_post(request_path).with(body: inputs).
      to_return(body: body, status: status,
                headers: { content_type: "application/json; charset=utf-8" })
  end

  after { reset_authentication_for subject }

  context "resource created successfully" do
    let(:body)   { fixture('projects/columns/column.json') }
    let(:status) { 201 }

    context "for the authenticated user" do
      let(:request_path) { "/projects/#{project_id}/columns?access_token=#{OAUTH_TOKEN}" }

      it "fails to create resource if 'name' inputs is missing" do
        expect {
          subject.create project_id, inputs.except(:name)
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "creates resource" do
        subject.create project_id, inputs
        expect(a_post(request_path).with(body: inputs)).to have_been_made
      end

      it "returns the resource" do
        column = subject.create project_id, inputs
        expect(column.name).to eq 'To Do'
      end

      it "returns mash type" do
        column = subject.create project_id, inputs
        expect(column).to be_a Github::ResponseWrapper
      end
    end
  end
end # create
