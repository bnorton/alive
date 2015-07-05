require 'spec_helper'

describe Checks do
  let(:user) { create(:user) }
  let(:test) { create(:test, :user => user) }
  let(:check) { create(:check, :test => test) }

  before { sign_in user }

  describe '#new' do
    let(:response) { get :new, :test_id => test.id }

    it 'should render the check new' do
      expect(response).to render_template('checks/new')
    end
  end

  describe '#create' do
    let(:options) { { :kind => Kind::Check::BODY, :key => 'foo', :value => 'bar.foo' } }
    let(:response) { post :create, :test_id => test.id, **options }

    it 'should redirect to the test' do
      expect(response).to redirect_to(test_path(test))
    end

    it 'should add the check' do
      expect {
        response
      }.to change(Check, :count).by(1)

      check = Check.last
      expect(check.test).to eq(test)
      expect(check.kind).to eq('body')
      expect(check.key).to eq('foo')
      expect(check.value).to eq('bar.foo')
    end
  end

  describe '#edit' do
    let(:response) { get :edit, :id => check.id }

    it 'should render the check edit' do
      expect(response).to render_template('checks/edit')
    end
  end

  describe '#update' do
    let(:kind) { Kind::Check::VALUES.sample }
    let(:options) { { :key => 'Location', :value => 'google.com', :kind => kind } }

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
