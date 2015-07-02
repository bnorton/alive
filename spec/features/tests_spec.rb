require 'spec_helper'

describe :tests, :js => true do
  let(:user) { create(:user) }

  before { sign_in user }

  describe '#index' do
    let!(:test1) { create(:test, :user => user, :url => 'https://staging.my-site.com', :last_code => 209, :last_duration => 274) }
    let!(:test2) { create(:test, :user => user, :url => 'http://my-site.com', :breed => 'post', :last_code => 501, :last_duration => 1240) }

    it 'lists the tests' do
      test2.update(:last_success => false)

      visit '/tests'

      should_be_on_the(:tests)

      expect(page).to have_content('API & Browser Tests')

      within "#test-#{test1.id}" do
        expect(page).to have_content('Passed')
        expect(page).to have_content('GET https://staging.my-site.com')
        expect(page).to have_content('209')
        expect(page).to have_content('274ms')
      end

      within "#test-#{test2.id}" do
        expect(page).to have_content('Failed')
        expect(page).to have_content('POST http://my-site.com')
        expect(page).to have_content('501')
        expect(page).to have_content('1240ms')
      end
    end

    it 'edits a test' do
      visit '/tests'

      within "#test-#{test2.id}" do
        click_link 'Edit'
      end

      expect(page).to have_content('API Test 2')
      expect(current_url).to match(/tests\/#{test2.id}/)
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

      it 'should expand the info' do
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

  describe '#show' do
    let(:test) { create(:test, :user => user, :url => 'http://my-site.com', :last_code => 219, :last_duration => 204, :last_at => 12.hours.ago) }

    it 'should show the test information' do
      visit "/tests/#{test.id}"

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

      # it 'edits a check' do
      #   within "#test-check-#{check2}" do
      #     click_link 'Edit'
      #
      #     expect(page).to have_content('Check 2')
      #     expect(current_url).to match(/checks\/#{check2.id}/)
      #   end
      # end
    end
  end
end
