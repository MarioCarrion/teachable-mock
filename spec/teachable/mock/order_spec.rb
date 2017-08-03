# frozen_string_literal: true

require 'spec_helper'

describe Teachable::Mock::Order, type: :model do
  let(:user) do
    Teachable::Mock::User.new(id:    322,
                              email: 'teachable@mock.com',
                              token: 'QPR_TDP3EaV7Qapd4_Vx')
  end

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
  end # create

  describe '#delete' do
    let(:attrs) { { 'id' => 492 } }

    context 'when all params are VALID', vcr: { cassette_name: 'orders_delete_valid_params' } do
      subject { described_class.new(user: user, attrs: attrs) }

      it 'deletes the record' do
        expect(subject.delete).to be true
        expect(subject.errors).to be_nil
      end
    end # when all params are VALId
  end # delete
end
