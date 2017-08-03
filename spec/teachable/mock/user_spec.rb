# frozen_string_literal: true

require 'spec_helper'

describe Teachable::Mock::User, type: :model do
  subject { described_class }

  describe '.authenticate' do
    context 'when all params are VALID', vcr: { cassette_name: 'authenticate_valid_params' } do
      it 'authenticates the user correctly' do
        error, user = subject.authenticate(email:    'teachable@mock.com',
                                           password: '12345678')

        expect(error).to be_nil

        expect(user.id).to be 322
        expect(user.email).to eql 'teachable@mock.com'
        expect(user.token).to eql 'QPR_TDP3EaV7Qapd4_Vx'
      end
    end # when all params are VALID

    context 'when params are INVALID', vcr: { cassette_name: 'authenticate_invalid_params' } do
      it 'returns error messages correctly' do
        error, user = subject.authenticate(email:    'teachable@mock.com',
                                           password: 'abcdefg99')

        expect(error).to eql('Invalid email or password.')

        expect(user).to be_nil
      end
    end # when params are INVALID
  end # .authenticate

  describe '.get' do
    context 'when all params are VALID', vcr: { cassette_name: 'get_valid_params' } do
      it 'authenticates the user correctly' do
        error, user = subject.get(email: 'teachable@mock.com',
                                  token: 'QPR_TDP3EaV7Qapd4_Vx')

        expect(error).to be_nil

        expect(user.id).to be 322
        expect(user.email).to eql 'teachable@mock.com'
        expect(user.token).to eql 'QPR_TDP3EaV7Qapd4_Vx'
      end
    end # when all params are VALID

    context 'when params are INVALID', vcr: { cassette_name: 'get_invalid_params' } do
      it 'returns error messages correctly' do
        error, user = subject.get(email: 'teachable@mock.com',
                                  token: 'fancy_token')

        expect(error).to eql('You need to sign in or sign up before continuing.')

        expect(user).to be_nil
      end
    end # when params are INVALID
  end # .authenticate

  describe '.register' do
    context 'when all params are VALID', vcr: { cassette_name: 'register_valid_params' } do
      it 'registers the user correctly' do
        error, user = subject.register(email:                 'teachable@mock.com',
                                       password:              '12345678',
                                       password_confirmation: '12345678')

        expect(error).to be_nil

        expect(user.id).to be 322
        expect(user.email).to eql 'teachable@mock.com'
        expect(user.token).to eql 'QPR_TDP3EaV7Qapd4_Vx'
      end
    end # when all params are VALID

    context 'when params are INVALID', vcr: { cassette_name: 'register_invalid_params' } do
      it 'returns error messages correctly' do
        error, user = subject.register(email:                 'teachable@com',
                                       password:              '12345',
                                       password_confirmation: 'i dont know')

        expect(error)
          .to match('email'                 => ['is invalid'],
                    'password'              => ['is too short (minimum is 8 characters)'],
                    'password_confirmation' => ["doesn't match Password"])

        expect(user).to be_nil
      end
    end # when params are INVALID
  end # .register
end
