require 'spec_helper'

describe Users do
  let(:user) { create(:user) }

  describe '#new' do
    let(:response) { get :new }

    it 'should render the sign up page' do
      expect(response).to render_template('users/new')
    end
  end

  describe '#create' do
    let(:response) { post :create, :email => 'john@example.com', :password => 'the-password' }

    it 'should add the user' do
      expect {
        response
      }.to change(User, :count).by(1)

      user = User.last
      expect(user.email).to eq('john@example.com')
      expect(user.password_is?('the-password')).to eq(true)
    end

    it 'should authenticate the user' do
      response

      user = User.last
      expect(controller.cookie(:id)).to eq(user.id.to_s)
      expect(controller.cookie(:token)).to eq(user.token)
    end

    it 'should go to the dashboard' do
      expect(response).to redirect_to(dashboard_index_path)
    end
  end

  describe '#show' do
    let(:response) { get :show }

    before { sign_in user }

    it 'should render the settings page' do
      expect(response).to render_template('users/show')
    end
  end

  describe '#update' do
    let(:response) { put :update, :id => user.id, :notify_slack => 'on' }

    before { sign_in user }

    it 'should update the user' do
      response

      expect(user.notify_email).to eq(false)
      expect(user.notify_slack).to eq(true)
    end

    it 'should go back to settings' do
      expect(response).to redirect_to(settings_path)
    end
  end
end
