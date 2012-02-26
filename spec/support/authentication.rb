shared_examples_for 'unauthenticated' do
  before do
    reset_authentication_for github
  end

  after do
    reset_authentication_for github
  end
end
