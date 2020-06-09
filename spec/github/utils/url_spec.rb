# encoding: utf-8

require 'spec_helper'

describe Github::Utils::Url do

  def eq_query_to(query)
    parts = query.split('&')
    lambda { |other| (parts & other.split('&')) == parts }
  end

  it 'escapes correctly' do
    expect(described_class.escape('<html>')).to eql '%3Chtml%3E'
    expect(described_class.escape('a space')).to eql 'a+space'
    expect(described_class.escape('\\/?}!@#$%^&*()')).to eql '%5C%2F%3F%7D%21%40%23%24%25%5E%26%2A%28%29'
  end

  it 'unescapes correctly' do
    expect(described_class.unescape('%3Chtml%3E')).to eql '<html>'
    expect(described_class.unescape('a+space')).to eql 'a space'
    expect(described_class.unescape('%5C%2F%3F%7D%21%40%23%24%25%5E%26%2A%28%29')).to eql '\\/?}!@#$%^&*()'
  end

  it 'normalizes correctly' do
    expect(described_class.normalize('github.api/$repos★/!usersÇ')).to eql 'github.api/$repos%E2%98%85/!users%C3%87'
    expect(described_class.normalize('123github!@')).to eql '123github!@'
    expect(described_class.normalize('github.api/repos/users')).to eql 'github.api/repos/users'
  end

  context 'parses query strings correctly' do
    it { expect(described_class.parse_query("a=b")).to eq 'a' => 'b' }
    it { expect(described_class.parse_query("a=b&a=c")).to eq 'a' => ['b','c'] }
    it { expect(described_class.parse_query("a=b&c=d")).to eq 'a' => 'b', 'c' => 'd' }
    it { expect(described_class.parse_query("a+b=%28c%29")).to eq 'a b' => '(c)' }
  end

  context 'builds query strings correctly' do
    it { expect( described_class.build_query("a" => "b")).to eq "a=b" }
    it { expect( described_class.build_query("a" => ["b", "c"])).to eq "a=b&a=c" }
    it { expect( described_class.build_query("a" => ["b", "c"])).to eq "a=b&a=c" }
    it { expect( described_class.build_query("a" => 1, "b" => 2)).to eq "a=1&b=2"}
  end

  context 'parse_query_for_param' do
    it 'returns nil if cannot find parameter' do
      expect(described_class.parse_query_for_param("param1=a;param2=b", 'param3')).to be nil
    end

    it 'returns value for given parameter name' do
      expect(described_class.parse_query_for_param("param1=a;param2=b", 'param1')).to eq 'a'
    end
  end

end # Github::Utils::Url
