require 'spec_helper'

describe :tests, :js => true do
  let(:user) { create(:user) }

  before { sign_in user }

  describe '#index' do
    let!(:test1) { create(:test, :user => user,  :url => 'https://staging.my-site.com', :interval => 24.hours, :name => 'Automated Test?', :last_code => 209, :last_duration => 274) }
    let!(:test2) { create(:test, :user => user, :url => 'http://my-site.com', :interval => 15.minutes, :breed => 'post', :last_code => 501, :last_duration => 1240) }

    it 'lists the tests' do
      test2.update(:last_success => false)

      visit '/tests'

      should_be_on_the(:tests)

      expect(page).to have_content('API & Browser Tests')

      within "#test-#{test1.id}" do
        find('.glyphicon-ok') # Success
        expect(page).to have_content('Automated Test?')
        expect(page).to have_content('GET https://staging.my-site.com every 1 day')
        expect(page).to have_content('209')
        expect(page).to have_content('274ms')
      end

      within "#test-#{test2.id}" do
        find('.glyphicon-remove') # Failed
        expect(page).to have_content('API Test 2')
        expect(page).to have_content('POST http://my-site.com every 15 minutes')
        expect(page).to have_content('501')
        expect(page).to have_content('1240ms')
      end
    end

    it 'edits a test' do
      visit '/tests'

      within "#test-#{test2.id}" do
        click_link 'More'
        click_link 'Edit'
      end

      expect(page).to have_content('Update Test')
      expect(current_url).to match(/tests\/#{test2.id}\/edit$/)
    end

    it 'runs a test' do
      visit '/tests'

      expect(TestRun.count).to eq(0)

      within "#test-#{test2.id}" do
        click_link 'More'
        click_button 'Run Now'
      end

      expect(current_url).to match(/tests\/#{test2.id}$/)

      expect(TestRun.count).to eq(1)

      test_run = TestRun.last
      expect(test_run.test).to eq(test2)
    end

    it 'shows a test' do
      visit '/tests'

      click_link 'API Test 2'

      expect(page).to have_content('API Test 2')
      expect(current_url).to match(/tests\/#{test2.id}$/)
    end

    it 'adds a check' do
      visit '/tests'

      within "#test-#{test2.id}" do
        click_link 'Add a Check'
      end

      expect(page).to have_content('Create Check')
      expect(current_url).to match(/tests\/#{test2.id}\/checks\/new/)
    end

    describe 'when there are checks' do
      before do
        create(:check, :test => test1, :kind => Kind::Check::STATUS, :value => '334')
        create(:check, :test => test1, :kind => Kind::Check::HEADER, :key => 'Content-Type', :value => 'application/javascript')
        create(:check, :test => test2, :kind => Kind::Check::BODY, :key => 'user.id', :value => '5549')
        create(:check, :test => test2, :kind => Kind::Check::BODY, :value => 'Homepage Title')
        create(:check, :test => test2, :kind => Kind::Check::TIME, :value => '500')
      end

      it 'lists the checks' do
        visit '/tests'

        within "#test-#{test1.id}" do
          expect(page).to have_content('Checks (2)')

          within '.test-checks' do
            expect(page).to have_content('Status equals 334')
            expect(page).to have_content('Header Content-Type equals application/javascript')
          end
        end

        within "#test-#{test2.id}" do
          expect(page).to have_content('Checks (3)')

          within '.test-checks' do
            expect(page).to have_content('JSON Object user.id equals 5549')
            expect(page).to have_content('HTML body contains Homepage Title')
            expect(page).to have_content('Response time is less than 500ms')
          end
        end
      end
    end

    describe 'when there is request metadata' do
      before do
        test1.update(
          :headers => {'Cookie' => 'abc=1234', 'Content-Type' => 'foo/bar'}.to_json,
          :body => { 'param1' => 'value1', 'param2' => 2 }.to_json
        )
      end

      it 'expands the info' do
        visit '/tests'

        within "#test-#{test1.id}" do
          find('a.test-headers-toggle').click
          expect(page).to have_content('Cookie: abc=123')
          expect(page).to have_content('Content-Type: foo/bar')

          find('a.test-body-toggle').click
          expect(page).to have_content('{"param1":"value1","param2":2}')
        end
      end
    end
  end

  describe '#create' do
    it 'creates the test' do
      visit '/tests/new'

      should_be_on_the(:'tests/new')

      expect(page).to have_content('Create Test')

      fill_in 'name', :with => 'Test Name YAY'
      fill_in 'url', :with => 'https://example.com/'
      select '15 Minutes', :from => 'interval'
      select 'POST', :from => 'breed'

      click_button 'Create'

      expect(current_url).to match(/tests\/.+/)

      test = Test.last
      expect(test.user).to eq(user)
      expect(test.name).to eq('Test Name YAY')
      expect(test.url).to eq('https://example.com/')
      expect(test.interval).to eq(15.minutes.to_i)
      expect(test.breed).to eq('post')
    end
  end

  describe '#show' do
    let(:test) { create(:test, :user => user, :url => 'http://my-site.com', :last_code => 219, :last_duration => 204, :last_at => 12.hours.ago) }

    it 'shows the test information' do
      visit "/tests/#{test.id}"

      should_be_on_the(:tests)

      expect(page).to have_content('API Test 1')
      expect(page).to have_content('GET http://my-site.com')
      expect(page).to have_content('Status 219')
      expect(page).to have_content('204ms')
      expect(page).to have_content('12 hours ago')
    end

    describe 'when there are checks' do
      let!(:check1) { create(:check, :test => test, :kind => Kind::Check::STATUS, :value => '296') }
      let!(:check2) { create(:check, :test => test, :kind => Kind::Check::TIME, :value => '980') }

      before do
        visit "/tests/#{test.id}"
      end

      it 'shows the checks' do
        within '.test-checks' do
          expect(page).to have_content('Status equals 296')
          expect(page).to have_content('Response time is less than 980ms')
        end
      end

      it 'edits a check' do
        within "#check-#{check2.id}" do
          expect(page).to have_content('Response time is less than 980ms')

          click_link 'Edit'
        end

        expect(page).to have_content('Update Check')
        expect(find('input[name=value]').value).to eq('980')
        expect(current_url).to match(/checks\/#{check2.id}\/edit/)
      end

      it 'adds a check' do
        click_link 'Add a Check'

        expect(page).to have_content('Create Check')
        expect(current_url).to match(/tests\/#{test.id}\/checks\/new/)
      end
    end

    describe 'when there are test runs' do
      let!(:test_run1) { create(:test_run, :user => user, :test => test, :at => 5.minutes.ago, :code => '202', :duration => 409, :headers => {'X-Processing-Latency' => 12, 'X-Run-By' => '1a'}.to_json) }
      let!(:test_run2) { create(:test_run, :user => user, :test => test) }

      it 'shows the test runs' do
        visit "/tests/#{test.id}"

        within "#test_run-#{test_run1.id}" do
          expect(page).to have_content('Passed 5 minutes ago')
          expect(page).to have_content('Status 202')
          expect(page).to have_content('409ms')

          find('a.test-headers-toggle').click
          expect(page).to have_content('X-Processing-Latency: 12')
          expect(page).to have_content('X-Run-By: 1a')
        end

        within "#test_run-#{test_run2.id}" do
          expect(page).to have_content('Pending')
          expect(page).to have_content('Status -')
        end

        test_run2.update(:code => 301, :duration => 509, :at => Time.now, :body => 'raw HTML body')

        # TODO make hookly callback
        visit current_url

        within "#test_run-#{test_run2.id}" do
          expect(page).to have_content('Passed less than a minute ago')
          expect(page).to have_content('Status 301')
          expect(page).to have_content('509ms')

          find('a.test-body-toggle').click
          expect(page).to have_content('raw HTML body')
        end
      end
    end
  end

  describe '#edit' do
    let(:test) { create(:test, :user => user) }

    it 'updates the test' do
      visit "/tests/#{test.id}/edit"

      should_be_on_the(:edit)

      expect(page).to have_content('Update Test')

      fill_in 'name', :with => 'Test Name YAY'
      fill_in 'url', :with => 'https://example.com/'
      select 'OPTIONS', :from => 'breed'

      click_button 'Save'

      expect(current_url).to match(/tests\/#{test.id}$/)

      test.reload
      expect(test.name).to eq('Test Name YAY')
      expect(test.url).to eq('https://example.com/')
      expect(test.breed).to eq('options')
    end
  end
end
