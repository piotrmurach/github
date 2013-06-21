# encoding: utf-8

require 'spec_helper'

describe Github::Utils::Url do

  def eq_query_to(query)
    parts = query.split('&')
    lambda { |other| (parts & other.split('&')) == parts }
  end

  it 'escapes correctly' do
    described_class.escape('<html>').should eql '%3Chtml%3E'
    described_class.escape('a space').should eql 'a+space'
    described_class.escape('\\/?}!@#$%^&*()').should eql '%5C%2F%3F%7D%21%40%23%24%25%5E%26%2A%28%29'
  end

  it 'unescapes correctly' do
    described_class.unescape('%3Chtml%3E').should eql '<html>'
    described_class.unescape('a+space').should eql 'a space'
    described_class.unescape('%5C%2F%3F%7D%21%40%23%24%25%5E%26%2A%28%29').should eql '\\/?}!@#$%^&*()'
  end

  context 'parses query strings correctly' do
    it { described_class.parse_query("a=b").should eq 'a' => 'b' }
    it { described_class.parse_query("a=b&a=c").should eq 'a' => ['b','c'] }
    it { described_class.parse_query("a=b&c=d").should eq 'a' => 'b', 'c' => 'd' }
    it { described_class.parse_query("a+b=%28c%29").should eq 'a b' => '(c)' }
  end

  context 'builds query strings correctly' do
    it { described_class.build_query("a" => "b").should eq "a=b" }
    it { described_class.build_query("a" => ["b", "c"]).should eq "a=b&a=c" }
    it { described_class.build_query("a" => ["b", "c"]).should eq "a=b&a=c" }
    it { described_class.build_query("a" => 1, "b" => 2).should eq "a=1&b=2"}
  end

  context 'parse_query_for_param' do
    it 'returns nil if cannot find parameter' do
      described_class.parse_query_for_param("param1=a;param2=b", 'param3').
        should be_nil
    end

    it 'returns value for given parameter name' do
      described_class.parse_query_for_param("param1=a;param2=b", 'param1').
        should eq 'a'
    end
  end

end # Github::Utils::Url
