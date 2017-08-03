# frozen_string_literal: true

require 'spec_helper'

describe Teachable::Mock::Configuration, type: :model do
  subject { described_class.new }

  describe '#hostname=' do
    context 'when value is invalid' do
      it 'raises error' do
        expect { subject.hostname = '  ' }.to raise_error('Value is required')
      end
    end # when value is invalid

    context 'when value is valid' do
      it 'accepts the value' do
        expect { subject.hostname = 'whatever' }.not_to raise_error
        expect(subject.hostname).to eql 'whatever'
      end
    end # when value is valid
  end # hostname=

  describe '#open_timeout' do
    it 'returns default value' do
      expect(subject.open_timeout).to be described_class::DEFAULT_OPEN_TIMEOUT
    end
  end # open_timeout

  describe '#open_timeout=' do
    context 'when value is not valid' do
      it 'raises error' do
        expect { subject.open_timeout = 0.0 }.to raise_error('Invalid value')
      end
    end # when value is not valid

    context 'when value is valid' do
      it 'accepts the value' do
        expect { subject.open_timeout = 1 }.not_to raise_error
        expect(subject.open_timeout).to be 1.0
      end
    end # when value is valid
  end # open_timeout=

  describe '#read_timeout' do
    it 'returns default value' do
      expect(subject.read_timeout).to be described_class::DEFAULT_OPEN_TIMEOUT
    end
  end # read_timeout

  describe '#read_timeout=' do
    context 'when value is not valid' do
      it 'raises error' do
        expect { subject.read_timeout = 0.0 }.to raise_error('Invalid value')
      end
    end # when value is not valid

    context 'when value is valid' do
      it 'accepts the value' do
        expect { subject.read_timeout = 2 }.not_to raise_error
        expect(subject.read_timeout).to be 2.0
      end
    end # when value is valid
  end # read_timeout=
end
