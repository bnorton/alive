require 'spec_helper'

describe Users do
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
      expect(response).to redirect_to(dashboard_path)
    end
  end
end
