require 'spec_helper'

describe Dashboards do
  let(:user) { create(:user) }

  before { sign_in user }

  describe '#index' do
    let(:response) { get :index }

    it 'should render the dashboard' do
      expect(response).to render_template('dashboards/index')
    end
  end
end
