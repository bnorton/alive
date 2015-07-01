require 'spec_helper'

describe Sessions do
  describe '#new' do
    let(:response) { get :new }

    it 'should render the sign up page' do
      expect(response).to render_template('sessions/new')
    end
  end

  describe '#create' do
    let(:password) { 'the-password' }
    let(:user) { create(:user, :email => 'john@example.com', :password => 'the-password') }

    let(:response) { post :create, :email => user.email, :password => password }

    it 'should authenticate the user' do
      response

      expect(controller.cookie(:id)).to eq(user.id.to_s)
      expect(controller.cookie(:token)).to eq(user.token)
    end

    it 'should go to the dashboard' do
      expect(response).to redirect_to(dashboard_index_path)
    end

    describe 'when the password does not match' do
      let(:password) { 'not-my-password' }

      it 'should go to login' do
        expect(response).to redirect_to(login_path)
      end

      it 'should not authenticate the user' do
        response

        expect(controller.cookie(:id)).to eq(nil)
        expect(controller.cookie(:token)).to eq(nil)
      end
    end
  end

  describe '#destroy' do
    let(:response) { get :destroy }

    it 'should go to login' do
      expect(response).to redirect_to(login_path)
    end

    it 'should de-authenticate the user' do
      response

      expect(controller.cookie(:id)).to eq('')
      expect(controller.cookie(:token)).to eq('')
    end
  end
end
