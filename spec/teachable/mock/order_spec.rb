# frozen_string_literal: true

require 'spec_helper'

describe Teachable::Mock::Order, type: :model do
  let(:user) do
    Teachable::Mock::User.new(id:    322,
                              email: 'teachable@mock.com',
                              token: 'QPR_TDP3EaV7Qapd4_Vx')
  end

  describe '.all' do
    context 'when all params are VALID', vcr: { cassette_name: 'orders_get_valid_params' } do
      it 'returns the associated orders' do
        errors, orders = described_class.all(user)

        expect(errors).to be_nil

        expect(orders.length).to be 1
        expect(orders[0].id).to be 493
        expect(orders[0].total).to eql '8.0'
        expect(orders[0].total_quantity).to be 33
        expect(orders[0].email).to eql 'teachable@mock.com'
      end
    end # when all params are VALID

    context 'when params are INVALID', vcr: { cassette_name: 'orders_get_invalid_params' } do
      let(:user) do
        Teachable::Mock::User.new(id:    0,
                                  email: 'teachable@mock.com',
                                  token: 'something')
      end

      it 'returns the errors' do
        errors, orders = described_class.all(user)

        expect(errors).to eql 'You need to sign in or sign up before continuing.'

        expect(orders).to match([])
      end
    end # when params are INVALID
  end # all

  describe '.create' do
    context 'when all params are VALID', vcr: { cassette_name: 'orders_post_valid_params' } do
      let(:attrs) do
        { 'number'         => 3,
          'total'          => 10,
          'total_quantity' => 99,
          'email'          => 'teachable@mock.com' }
      end

      it 'saves the record correctly' do
        errors, order = described_class.create(user: user, attrs: attrs)

        expect(errors).to be_nil

        expect(order.id).to be 492
        expect(order.total).to eql '10.0'
        expect(order.total_quantity).to be 99
        expect(order.email).to eql 'teachable@mock.com'
      end
    end # when all params are VALID

    context 'when params are INVALID', vcr: { cassette_name: 'orders_post_invalid_params' } do
      let(:attrs) { { 'number' => 3, 'email' => 'teachable@mock.com' } }

      it 'returns the erorrs' do
        errors, order = described_class.create(user: user, attrs: attrs)

        expect(errors)
          .to match([{ 'id' => 'total',          'title' => "Total can't be blank" },
                     { 'id' => 'total_quantity', 'title' => "Total quantity can't be blank" }])

        expect(order).to be_nil
      end
    end # when all params are INVALID
  end # create

  describe '#delete' do
    context 'when all params are VALID', vcr: { cassette_name: 'orders_delete_valid_params' } do
      subject { described_class.new(user: user, attrs: attrs) }

      let(:attrs) { { 'id' => 492 } }

      it 'deletes the record' do
        expect(subject.delete).to be true
        expect(subject.errors).to be_nil
      end
    end # when all params are VALID

    context 'when params are INVALID', vcr: { cassette_name: 'orders_delete_invalid_params' } do
      subject { described_class.new(user: user, attrs: attrs) }

      let(:user) do
        Teachable::Mock::User.new(id:    322,
                                  email: 'teachable@mock.com',
                                  token: '')
      end

      let(:attrs) { { 'id' => 494 } }

      it 'returns the errors' do
        expect(subject.delete).to be false
        expect(subject.errors).to eql 'You need to sign in or sign up before continuing.'
      end
    end # when all params are INVALID

    context 'when id is missing', vcr: { cassette_name: 'orders_delete_invalid_params_id' } do
      subject { described_class.new(user: user, attrs: attrs) }

      let(:attrs) { {} }

      it 'returns the errors' do
        expect(subject.delete).to be false
        expect(subject.errors).to be_nil
      end
    end # when id is missing
  end # delete
end
