# encoding: utf-8

shared_examples_for 'an array of resources' do

  it "should return array of resources" do
    objects = requestable
    expect(objects).to be_a Enumerable
    expect(objects.size).to be 1
  end

  it "is_expected.to be a mash type" do
    objects = requestable
    expect(objects.first).to be_a ::Github::Mash
  end
end
