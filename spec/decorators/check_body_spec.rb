require 'spec_helper'

describe CheckBody do
  let(:key) { nil }
  let(:value) { 'foo-bar' }
  let(:body) { '<div class="foo-bar foo-baz"></div>' }
  let(:check) { create(:check, :kind => Kind::Check::BODY, :key => key, :value => value) }
  let(:response) { Response.from_api.tap {|r| r.body = body } }

  subject { check.decorator.new(check) }

  its(:class) { should == CheckBody }

  describe '#to_s' do
    its(:to_s) { should == 'HTML body contains foo-bar' }

    describe 'when there a key' do
      before do
        check.key = 'user.name'
      end

      its(:to_s) { should == 'JSON Object user.name equals foo-bar' }
    end
  end

  describe '#call' do
    let(:call) { subject.call(response) }

    it 'should be successful' do
      call

      expect(subject.success?).to eq(true)
    end

    it 'should have the response' do
      call

      expect(subject.response).to be(response)
    end

    describe 'when the value is not found' do
      let(:value) { 'foo-foo' }

      it 'should not be successful' do
        call

        expect(subject.success?).to eq(false)
      end
    end

    describe 'for a json body' do
      let(:key) { 'code' }
      let(:value) { '202' }
      let(:body) { { 'code' => '202', 'user' => {'id' => 9, 'name' => { 'first' => 'John', 'last' => 'Doe' } } } }

      it 'should be successful' do
        call

        expect(subject.success?).to eq(true)
      end

      describe 'when the value is different' do
        let(:value) { '301' }

        it 'should not be successful' do
          call

          expect(subject.success?).to eq(false)
        end
      end

      describe 'for key paths' do
        [['code', '202'], ['user.id', '9'], ['user.name.first', 'John']].each do |(k, v)|
          describe "for #{k} = #{v}" do
            let(:key) { k }
            let(:value) { v }

            it 'should be successful' do
              call

              expect(subject.success?).to eq(true)
            end
          end
        end

        [['missing', '22'], ['user.id', '22'], ['user.missing.name', 'John']].each do |(k, v)|
          describe "for #{k}" do
            let(:key) { k }
            let(:value) { v }

            it 'should not be successful' do
              call

              expect(subject.success?).to eq(false)
            end
          end
        end
      end
    end

    describe 'for a capybara session' do
      let(:session) { instance_double(Capybara::Session, :has_text? => true) }
      let(:response) { Response.from_browser(session) }

      before do
        allow(Capybara::Session).to receive(:===).and_call_original
        allow(Capybara::Session).to receive(:===).with(session).and_return(true)
      end

      it 'should query the session' do
        expect(session).to receive(:has_text?) do |r|
          expect(r).to eq(/foo\-bar/i)
        end

        call
      end

      it 'should be successful' do
        call

        expect(subject.success?).to eq(true)
      end

      describe 'when the text cant be found' do
        let(:session) { instance_double(Capybara::Session, :has_text? => false) }

        it 'should not be successful' do
          call

          expect(subject.success?).to eq(false)
        end
      end
    end
  end
end
