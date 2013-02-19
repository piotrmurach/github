# encoding: utf-8

shared_examples_for 'an array of resources' do

  it "should return array of resources" do
    objects = requestable
    objects.should be_a Enumerable
    objects.should have(1).items
  end

  it "should be a mash type" do
    objects = requestable
    objects.first.should be_a Hashie::Mash
  end
end
