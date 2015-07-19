require 'spec_helper'

describe :hooks, :js => true do
  let(:user) { create(:user) }

  before { sign_in user }

  describe '#create' do
    let!(:test) { create(:test, :user => user) }
    let(:hook) { create(:hook, :test => test) }

    it 'creates the hook' do
      visit "/tests/#{test.id}/hooks/new"

      should_be_on_the(:'hooks/new')

      expect(page).to have_content('Create WebHook')

      hook_name = 'Test Hook Name'
      hook_url = 'http://www.example.com'

      fill_in 'name', :with => hook_name
      fill_in 'url', :with => hook_url
      check 'include_response'
      check 'enabled'

      click_button 'Create'

      expect(current_url).to match(/tests\/#{test.id}$/)

      hook = Hook.last
      expect(hook.test).to eq(test)
      expect(hook.name).to eq(hook_name)
      expect(hook.url).to eq(hook_url)
      expect(hook.include_response).to eq(true)
      expect(hook.enabled).to eq(true)
    end
  end

  describe '#edit' do
    let(:test) { create(:test, :user => user) }
    let(:hook) { create(:hook, :test => test) }

    it 'updates the hook' do
      visit "/hooks/#{hook.id}/edit"

      should_be_on_the(:edit)

      expect(page).to have_content('Update WebHook')

      hook_name = 'Edited Test Hook Name'
      hook_url = 'http://edit.example.com'

      fill_in 'name', :with => hook_name
      fill_in 'url', :with => hook_url
      check 'include_response'
      check 'enabled'

      click_button 'Save'

      expect(current_url).to match(/tests\/#{test.id}$/)

      hook.reload
      expect(hook.name).to eq(hook_name)
      expect(hook.url).to eq(hook_url)
      expect(hook.include_response).to eq(true)
      expect(hook.enabled).to eq(true)
    end
  end
end
