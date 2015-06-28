require 'spec_helper'

describe Check do
  subject { build(:check) }

  describe 'validations' do
    it 'requires a test' do
      subject.test_id = nil
      expect(subject).not_to be_valid
    end
  end

  describe '#save' do
    describe 'on create' do
      it 'should have the next check index' do
        subject.test = test = create(:test).tap {|t| t.update(:check_index => 23) }
        subject.save

        expect(subject.index).to eq(24)
        expect(test.check_index).to eq(24)
      end

      describe 'first check test run' do
        let(:test) { create(:test) }

        before do
          subject.test = test
        end

        it 'should process the test' do
          expect(TestWorker).to receive(:perform_async).with(test.id)

          subject.save
        end

        describe 'when the first check has been created' do
          before do
            create(:check, :test => test)
          end

          it 'should not process the test' do
            expect(TestWorker).not_to receive(:perform_async)

            subject.save
          end
        end
      end
    end
  end

  describe '#decorator' do
    Kind::Check::VALUES.each do |kind|
      it "should have the #{kind} decorator" do
        subject.kind = kind

        expect(subject.decorator).to eq("Check#{kind.titleize}".constantize)
      end
    end
  end
end
