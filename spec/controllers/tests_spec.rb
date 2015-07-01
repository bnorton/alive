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
end
