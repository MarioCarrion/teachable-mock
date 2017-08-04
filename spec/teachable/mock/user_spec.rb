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

  describe '#create_order' do
    context 'when all params are VALID', vcr: { cassette_name: 'orders_post_valid_params' } do
      subject {
        described_class.new(id:    322,
                            email: 'teachable@mock.com',
                            token: 'QPR_TDP3EaV7Qapd4_Vx')
      }

      let(:attrs) do
        { 'number'         => 3,
          'total'          => 10,
          'total_quantity' => 99,
          'email'          => 'teachable@mock.com' }
      end

      it 'saves the record correctly' do
        order = subject.create_order(attrs)

        expect(subject.errors).to be_nil

        expect(order.id).to be 492
        expect(order.total).to eql '10.0'
        expect(order.total_quantity).to be 99
        expect(order.email).to eql 'teachable@mock.com'
      end
    end # when all params are VALID
  end # create_order

  describe '#orders', vcr: { cassette_name: 'orders_get_valid_params' } do
    context 'when params are VALID' do
      subject {
        described_class.new(id:    322,
                            email: 'teachable@mock.com',
                            token: 'QPR_TDP3EaV7Qapd4_Vx')
      }

      it 'returns the orders associated to the user' do
        orders = subject.orders

        expect(subject.errors).to be_nil

        expect(orders.length).to be 1
        expect(orders[0].id).to be 493
        expect(orders[0].total).to eql '8.0'
        expect(orders[0].total_quantity).to be 33
        expect(orders[0].email).to eql 'teachable@mock.com'
      end
    end # when params are valid

    context 'when params are INVALID', vcr: { cassette_name: 'orders_get_invalid_params' } do
      subject {
        described_class.new(id:    0,
                            email: 'teachable@mock.com',
                            token: 'something')
      }

      it 'returns nil and sets the error message' do
        orders = subject.orders

        expect(orders).to be_nil
        expect(subject.errors).to eql 'You need to sign in or sign up before continuing.'
      end
    end # when params are valid
  end # orders
end
