require 'spec_helper'

describe Github::Validation, :type => :base do

  context '#_validate_inputs' do
    before do
      @required = ['param_a', 'param_c']
      @provided = { 'param_a' => true, 'param_c' => true }
    end

    it 'detect missing parameter' do
      github._validate_inputs(@required, @provided.except('param_c')).should be_false
    end

    it 'asserts correct required parameters' do
      github._validate_inputs(@required, @provided).should be_true
    end
  end

  context '#_validate_presence_of' do
    it 'throws error if passed param is nil' do
      gist_id = nil
      expect {
        github._validate_presence_of gist_id
      }.to raise_error(ArgumentError)
    end
  end

  context '#_validate_params_values' do
    let(:permitted) {
      {
        'param_a' => ['a', 'b'],
        'param_b' => /^github$/
      }
    }

    it 'fails to accept unkown value for a given parameter key' do
      actual = { 'param_a' => 'x' }
      expect {
        github._validate_params_values(permitted, actual)
      }.to raise_error(ArgumentError)
    end

    it 'accepts known value for a given parameter key' do
      actual = { 'param_a' => 'a'}
      github._validate_params_values(permitted, actual)
    end

    it 'fails to match regex value for a given parameter key' do
      actual = { 'param_b' => 'xgithub' }
      expect {
        github._validate_params_values(permitted, actual)
      }.to raise_error(ArgumentError)
    end

    it 'matches regex value for a given parameter key' do
      actual = { 'param_b' => 'github'}
      github._validate_params_values(permitted, actual)
    end
  end
end # Github::Validation
