require 'spec_helper'

describe Checks do
  let(:user) { create(:user) }

  before { sign_in user }

  describe '#edit' do
    let(:test) { create(:test, :user => user) }
    let(:check) { create(:check, :test => test) }

    let(:response) { get :edit, :id => check.id }

    it 'should render the check edit' do
      expect(response).to render_template('checks/edit')
    end
  end

  describe '#update' do
    let(:kind) { Kind::Check::VALUES.sample }
    let(:options) { { :key => 'Location', :value => 'google.com', :kind => kind } }
    let(:test) { create(:test, :user => user) }
    let(:check) { create(:check, :test => test) }

    let(:response) { patch :update, :id => check.id, **options }

    it 'should redirect to the test' do
      expect(response).to redirect_to(test_path(test))
    end

    it 'should update the check' do
      response

      check.reload
      expect(check.key).to eq('Location')
      expect(check.value).to eq('google.com')
      expect(check.kind).to eq(kind)
    end
  end
end
