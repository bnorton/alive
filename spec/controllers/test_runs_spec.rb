require 'spec_helper'

describe TestRuns do
  let(:user) { create(:user) }
  let(:test) { create(:test, :user => user) }

  before { sign_in user }

  describe '#create' do
    let(:response) { post :create, :test_id => test.id }

    it 'should create a new test run' do
      expect {
        response
      }.to change(TestRun, :count).by(1)
    end

    it 'should have the attributes' do
      response

      test_run = TestRun.last
      expect(test_run.user).to eq(user)
      expect(test_run.test).to eq(test)
    end

    it 'should redirect to the test run' do
      response

      expect(response).to redirect_to(test_path(test))
    end
  end
end
