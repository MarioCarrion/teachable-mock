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
        def all(user)
          c = Client.new(Mock.configuration.hostname)
          query = "user_email=#{user.email}&user_token=#{user.token}"
          errors, json = c.request(type: :get, path: '/api/orders.json', query: query)
          return [errors, []] unless errors.nil?
          [nil, json.map { |attrs| Order.new(user: user, attrs: attrs) }]
        end

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
        client = Client.new(Mock.configuration.hostname)
        query = "user_email=#{user.email}&user_token=#{user.token}"
        @errors, json = client.request(type:  :delete,
                                       path:  "/api/orders/#{id}.json",
                                       query: query)
        return false if !errors.nil? || json&.dig('status') == '404'
        true
      end
    end # class
  end
end
