
require 'spec_helper'

describe :sessions, :js => true do
  let!(:user) { create(:user, :password => 'a-password') }

  describe '#create' do
    it 'should login the user' do
      visit '/login'

      fill_in 'email', :with => user.email
      fill_in 'password', :with => 'a-password'

      click_button 'Login'

      should_be_on_the_dashboard

      click_link 'Log out'

      expect(page).not_to have_content('Tests')
      expect(current_url).to match(/login/)
    end
  end

  describe '#desroy' do
    before { sign_in user }

    it 'should logout the user' do
      visit '/dashboard'

      should_be_on_the_dashboard
      click_link 'Log out'

      expect(current_url).to match(/login/)
    end
  end
end


