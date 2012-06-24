require 'spec_helper'

describe Github::API do
  let(:api) { Github::API.new }
  let(:repos) { Github::Repos }

  it { described_class.included_modules.should include Github::Authorization }
  it { described_class.included_modules.should include Github::MimeType }
  it { described_class.included_modules.should include Github::Connection }
  it { described_class.included_modules.should include Github::Request }

  context 'actions' do
    it { described_class.new.should respond_to :api_methods_in }

    it 'dynamically adds actions inspection to classes inheriting from api' do
      repos.should respond_to :actions
      repos.new.should respond_to :actions
    end

    it 'ensures output contains api methods' do
      methods = [ 'method_a', 'method_b']
      repos.stub(:instance_methods).and_return methods
      output = capture(:stdout) { 
        api.api_methods_in(repos)
      }
      output.should =~ /.*method_a.*/
      output.should =~ /.*method_b.*/
    end
  end

  context '_process_basic_auth' do
    let(:github) { Github.new :basic_auth => 'login:password' }

    after { reset_authentication_for github }

    it 'should parse authentication params' do
      github.login.should eq 'login'
      github.password.should eq 'password'
    end
  end

  context '_set_api_client' do
    it 'should set instantiated api class as main api client' do
      repos_instance = repos.new
      Github.api_client.should eq repos_instance
    end
  end

  context 'normalize!' do
    before do
      @params = { 'a' => { :b => { 'c' => 1 }, 'd' => [ 'a', { :e => 2 }] } }
    end

    it "should stringify all the keys inside nested hash" do
      actual = api.normalize! @params
      expected = { 'a' => { 'b'=> { 'c' => 1 }, 'd' => [ 'a', { 'e'=> 2 }] } }
      actual.should be_eql expected
    end
  end

  context 'filter!' do
    it "should remove non valid param keys" do
      valid = ['a', 'b', 'e']
      hash = {'a' => 1, 'b' => 3, 'c' => 2, 'd'=> 4, 'e' => 5 }
      actual = api.filter! valid, hash
      expected = {'a' => 1, 'b' => 3, 'e' => 5 }
      actual.should be_eql expected
    end
  end

end # Github::API
