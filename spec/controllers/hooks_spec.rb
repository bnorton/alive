require 'spec_helper'

describe Hooks do
  let(:user) { create(:user) }
  let(:test) { create(:test, :user => user) }
  let(:hook) { create(:hook, :test => test) }

  before { sign_in user }

  describe '#new' do
    let(:response) { get :new, :test_id => test.id }

    it 'should render the hook new' do
      expect(response).to render_template('hooks/new')
    end
  end

  describe '#create' do
    hook_name = 'Test Hook Name'
    hook_url = 'http://www.example.com'

    let(:options) { { :url => hook_url, :name => hook_name, :include_response => "on" } }
    let(:response) { post :create, :test_id => test.id, **options }

    it 'should redirect to the test' do
      expect(response).to redirect_to(test_path(test))
    end

    it 'should add the hook' do
      expect {
        response
      }.to change(Hook, :count).by(1)

      hook = Hook.last
      expect(hook.url).to eq(hook_url)
      expect(hook.name).to eq(hook_name)
      expect(hook.include_response).to eq(true)
    end

    describe '.json' do
      before { options[:format] = 'json' }

      it 'should return the hook' do
        json = JSON.parse(response.body)

        hook = Hook.last
        expect(json['id']).to eq(hook.id.to_s)
        expect(json['url']).to eq(hook_url)
        expect(json['name']).to eq(hook_name)
        expect(json['include_response']).to eq(true)
      end
    end
  end

  describe '#edit' do
    let(:response) { get :edit, :id => hook.id }

    it 'should render the hook edit' do
      expect(response).to render_template('hooks/edit')
    end
  end

  describe '#update' do

    hook_name = 'Edit Test Hook Name'
    hook_url = 'http://edit.example.com'

    let(:options) { { :url => hook_url, :name => hook_name, :include_response => "on" } }
    let(:response) { patch :update, :id => hook.id, **options }

    it 'should redirect to the test' do
      expect(response).to redirect_to(test_path(test))
    end

    it 'should update the hook' do
      response

      hook.reload
      expect(hook.url).to eq(hook_url)
      expect(hook.name).to eq(hook_name)
      expect(hook.include_response).to eq(true)
    end

    describe '.json' do
      before { options[:format] = 'json' }

      it 'should return the hook' do
        json = JSON.parse(response.body)

        expect(json['id']).to eq(hook.id.to_s)
        expect(json['url']).to eq(hook_url)
        expect(json['name']).to eq(hook_name)
        expect(json['include_response']).to eq(true)
      end
    end
  end
end
