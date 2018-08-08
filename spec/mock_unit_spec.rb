require 'active_support'
require 'active_support/core_ext/numeric'
require './mock_unit'

SUCCEED = 'succeed'.freeze
FAIL = 'fail'.freeze
ERROR = 'error'.freeze

NO_DURATION = 0
MEDIUM_DURATION = 3.in_milliseconds

RSpec.describe MockUnit, '#mock_unit' do
  context 'on success' do
    context 'with no duration' do
      it 'should succeed quickly' do
        expect(MockUnit.method(SUCCEED, NO_DURATION)).to eq true
      end
    end

    context 'with some duration' do
      it 'should succeed slowly' do
        expect(MockUnit.method(SUCCEED, MEDIUM_DURATION)).to eq true
      end
    end
  end

  context 'on failure' do
    context 'with no duration' do
      it 'should fail quickly' do
        expect(MockUnit.method(FAIL, NO_DURATION)).to eq true
      end
    end

    context 'with some duration' do
      it 'should fail slowly' do
        expect(MockUnit.method(FAIL, MEDIUM_DURATION)).to eq true
      end
    end
  end

  context 'on error' do
    context 'with no duration' do
      it 'should error quickly' do
        expect(MockUnit.method(ERROR, NO_DURATION)).to eq true
      end
    end

    context 'with some duration' do
      it 'should error slowly' do
        expect(MockUnit.method(ERROR, MEDIUM_DURATION)).to eq true
      end
    end
  end
end