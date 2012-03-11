require 'spec_helper'

describe Github::Response::Helpers do
  let(:env) { { :body => [1,2,3] } }
  let(:instance) { described_class.new }

  it 'includes result helper methods' do
    res = instance.on_complete(env)
    res[:body].class.included_modules.should include Github::Result
  end

  it 'should extend result with environemnt getter' do
    res = instance.on_complete(env)
    res[:body].should respond_to :env
  end
end # Github::Response::Helpers
