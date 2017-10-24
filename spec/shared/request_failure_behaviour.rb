# encoding: utf-8

shared_examples_for 'request failure' do

  context "resource not found" do
    let(:body)   { "" }
    let(:status) { [404, "Not Found"] }

    it "should fail to retrive resource" do
      expect {
        requestable
      }.to raise_error(Github::Error::NotFound)
    end
  end

end
