require 'spec_helper'

describe :users, :js => true do
  describe '#create' do
    it 'should add a new user' do
      visit '/sign-up'

      fill_in 'email', :with => 'john@example.com'
      fill_in 'password', :with => 'my-password'

      click_button 'Sign Up'

      should_be_on_the(:dashboard)

      user = User.last
      expect(user.email).to eq('john@example.com')
    end
  end
end
