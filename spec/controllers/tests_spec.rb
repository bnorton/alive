require 'spec_helper'

describe Tests do
  let(:user) { create(:user) }

  before { sign_in user }

  describe '#index' do
    let(:response) { get :index }

    it 'should render the tests' do
      expect(response).to render_template('tests/index')
    end
  end

  describe '#new' do
    let(:response) { get :new }

    it 'should render the new test' do
      expect(response).to render_template('tests/new')
    end
  end

  describe '#create' do
    let(:options) { { :name => 'Test Name', :url => 'test-url', :breed => 'post' } }

    let(:response) { patch :create, **options }

    it 'should redirect to the test' do
      response

      expect(response).to redirect_to(test_path(Test.last))
    end

    it 'should add the test' do
      expect {
        response
      }.to change(Test, :count).by(1)

      test = Test.last
      expect(test.name).to eq('Test Name')
      expect(test.breed).to eq('post')
      expect(test.url).to eq('test-url')
    end

    describe '.json' do
      before { options[:format] = 'json' }

      it 'should return the test' do
        json = JSON.parse(response.body)

        test = Test.last
        expect(json['id']).to eq(test.id.to_s)
        expect(json['name']).to eq('Test Name')
      end
    end
  end

  describe '#show' do
    let(:test) { create(:test, :user => user) }

    let(:response) { get :show, :id => test.id }

    it 'should render the test' do
      expect(response).to render_template('tests/show')
    end
  end

  describe '#edit' do
    let(:test) { create(:test, :user => user) }

    let(:response) { get :edit, :id => test.id }

    it 'should render the test edit' do
      expect(response).to render_template('tests/edit')
    end
  end

  describe '#update' do
    let(:options) { { :name => 'New Name', :url => 'new-url', :breed => 'head' } }
    let(:test) { create(:test, :user => user) }

    let(:response) { patch :update, :id => test.id, **options }

    it 'should redirect to the test' do
      expect(response).to redirect_to(test_path(test))
    end

    it 'should update the test' do
      response

      test.reload
      expect(test.name).to eq('New Name')
      expect(test.breed).to eq('head')
      expect(test.url).to eq('new-url')
    end

    describe '.json' do
      before { options[:format] = 'json' }

      it 'should return the test' do
        json = JSON.parse(response.body)

        expect(json['id']).to eq(test.id.to_s)
        expect(json['name']).to eq('New Name')
      end
    end
  end
end
