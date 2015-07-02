require 'spec_helper'

describe Tests do
  let(:user) { create(:user) }

  before { sign_in user }

  describe '#index' do
    let(:response) { get :index }

    it 'should render the tests' do
      expect(response).to render_template('tests/index')
    end
  end

  describe '#show' do
    let(:test) { create(:test, :user => user) }

    let(:response) { get :show, :id => test.id }

    it 'should render the test' do
      expect(response).to render_template('tests/show')
    end
  end
end
