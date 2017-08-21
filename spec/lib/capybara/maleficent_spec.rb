require 'spec_helper'
require 'capybara/maleficent'

RSpec.describe Capybara::Maleficent do
  it "has a version number" do
    expect(Capybara::Maleficent::VERSION).not_to be nil
  end

  describe '.with_sleep_injection' do
    let(:the_sleeper) { double(sleep: true) }
    let(:sleep_durations) { [1, 2, 3] }
    let(:kwargs) { { sleep_durations: sleep_durations, handled_exceptions: [RuntimeError], the_sleeper: the_sleeper } }
    let(:sleep_injector) { }

    describe "when the first attempt raises the handled exception" do
      describe "but the second to last interval does not raise a handled exception" do
        it 'will return the return value of the given block' do
          sleep_durations[0..-3].each do |i|
            expect(the_sleeper).to receive(:sleep).with(i).ordered
          end
          sleep_durations[-3..-1].each do |i|
            expect(the_sleeper).not_to receive(:sleep).with(i)
          end
          counter = 0
          returned_value = Capybara::Maleficent.with_sleep_injection(**kwargs) do
            counter += 1
            raise RuntimeError unless counter == sleep_durations[-2]
            counter
          end
          expect(returned_value).to eq(sleep_durations[-2])
        end
      end
      describe "but the last interval does not raise a handled exception" do
        it 'will return the return value of the given block' do
          sleep_durations.each do |i|
            expect(the_sleeper).to receive(:sleep).with(i).ordered
          end
          counter = 0
          returned_value = Capybara::Maleficent.with_sleep_injection(**kwargs) do
            counter += 1
            raise RuntimeError if counter < sleep_durations.size
            counter
          end
          expect(returned_value).to eq(sleep_durations.size)
        end
      end
      describe "and all intervals raises a handled exception" do
        it 'will sleep each time then raise the exception' do
          sleep_durations.each do |i|
            expect(the_sleeper).to receive(:sleep).with(i).ordered
          end
          expect do
            Capybara::Maleficent.with_sleep_injection(**kwargs) do
              raise RuntimeError
            end
          end.to raise_error(RuntimeError)
        end
      end
    end

    describe "when the first attempt raises an unhandled exception" do
      let(:returned_value) { double }
      subject do
        Capybara::Maleficent.with_sleep_injection(**kwargs) do
          raise KeyError
        end
      end
      it 'does not sleep' do
        expect { subject }.to raise_error(KeyError)
        expect(the_sleeper).not_to have_received(:sleep)
      end
      it 'raises the failing exception' do
        expect { subject }.to raise_error(KeyError)
      end
    end

    describe "when the first attempt is successful" do
      let(:returned_value) { double }
      subject do
        Capybara::Maleficent.with_sleep_injection(**kwargs) do
          returned_value
        end
      end
      it 'does not sleep' do
        subject
        expect(the_sleeper).not_to have_received(:sleep)
      end
      it 'returns the value of the yielded block' do
        expect(subject).to eq(returned_value)
      end
    end
  end
end
