# frozen_string_literal: true

module Teachable
  module Mock
    class Order
      attr_reader :email,
                  :errors,
                  :id,
                  :number,
                  :special_instructions,
                  :total,
                  :total_quantity,
                  :user

      class << self
        def create(user:, attrs:)
          client  = Client.new(Mock.configuration.hostname)
          payload = Yajl::Encoder.encode(order: attrs)
          query   = "user_email=#{user.email}&user_token=#{user.token}"
          errors, json = client.request(type:    :post,
                                        path:    '/api/orders.json',
                                        query:   query,
                                        payload: payload)
          return [errors, nil] unless errors.nil?

          [nil, Order.new(user: user, attrs: json)]
        end
      end # << self

      def initialize(user:, attrs:)
        @user                 = user

        @email                = attrs['email']
        @id                   = attrs['id']
        @number               = attrs['number']
        @special_instructions = attrs['special_instructions']
        @total                = attrs['total']
        @total_quantity       = attrs['total_quantity']
      end

      def delete
        raise ArgumentError, 'Record must be persisted first' if id.nil?

        client = Client.new(Mock.configuration.hostname)
        query = "user_email=#{user.email}&user_token=#{user.token}"
        @errors, = client.request(type:  :delete,
                                  path:  "/api/orders/#{id}.json",
                                  query: query)
        return false unless errors.nil?
        true
      end
    end # class
  end
end
