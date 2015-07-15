require 'spec_helper'

describe :users, :js => true do
  let(:user) { create(:user) }

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

  describe '#show' do
    before { sign_in user }

    it 'shows the api key' do
      visit '/settings'

      expect(page).to have_content("API Key: #{user.token}")
    end

    it 'configures notifications' do
      visit '/settings'

      expect(page).to have_content('Notifying via email on change in status.')

      check 'notify_slack'
      click_button 'Update'
      expect(page).to have_content('Notifying via slack and email on change in status.')

      uncheck 'notify_email'
      click_button 'Update'
      expect(page).to have_content('Notifying via slack on change in status.')

      uncheck 'notify_slack'
      click_button 'Update'
      expect(page).to have_content('You will not be notified of failing tests.')
    end
  end
end
