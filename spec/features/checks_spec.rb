require 'spec_helper'

describe :checks, :js => true do
  let(:user) { create(:user) }

  before { sign_in user }

  describe '#create' do
    let!(:test) { create(:test, :user => user) }
    let(:check) { create(:check, :test => test) }

    it 'creates the check' do
      visit "/tests/#{test.id}/checks/new"

      expect(page).to have_content('Create Check')

      select 'Header', :from => 'kind'
      fill_in 'key', :with => 'Content-Type'
      fill_in 'value', :with => 'foo/json'

      click_button 'Create'

      expect(current_url).to match(/tests\/#{test.id}$/)

      check = Check.last
      expect(check.test).to eq(test)
      expect(check.key).to eq('Content-Type')
      expect(check.value).to eq('foo/json')
      expect(check.kind).to eq('header')
    end
  end

  describe '#edit' do
    let(:test) { create(:test, :user => user) }
    let(:check) { create(:check, :test => test) }

    it 'updates the check' do
      visit "/checks/#{check.id}/edit"

      expect(page).to have_content('Update Check')

      select 'Header', :from => 'kind'
      fill_in 'key', :with => 'Content-Type'
      fill_in 'value', :with => 'foo/json'

      click_button 'Save'

      expect(current_url).to match(/tests\/#{test.id}$/)

      check.reload
      expect(check.key).to eq('Content-Type')
      expect(check.value).to eq('foo/json')
      expect(check.kind).to eq('header')
    end
  end
end
