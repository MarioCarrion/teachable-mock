# frozen_string_literal: true

module Teachable
  module Mock
    class User
      class << self
        def authenticate(email:, password:)
          c = Client.new(Mock.configuration.hostname)
          payload = Yajl::Encoder.encode(user: { email: email,
                                                 password: password })
          errors, json = c.request(type: :post, path: '/users/sign_in.json', payload: payload)
          return [errors, nil] unless errors.nil?

          [nil, User.new(id: json['id'], email: json['email'], token: json['tokens'])]
        end

        def get(email:, token:)
          c = Client.new(Mock.configuration.hostname)
          query = "user_email=#{email}&user_token=#{token}"
          errors, json = c.request(type: :get, path: '/api/users/current_user/edit.json', query: query)
          return [errors, nil] unless errors.nil?

          [nil, User.new(id: json['id'], email: json['email'], token: json['tokens'])]
        end

        def register(email:, password:, password_confirmation:)
          c = Client.new(Mock.configuration.hostname)
          payload = Yajl::Encoder.encode(user: { email: email,
                                                 password: password,
                                                 password_confirmation: password_confirmation })
          errors, json = c.request(type: :post, path: '/users.json', payload: payload)
          return [errors, nil] unless errors.nil?

          [nil, User.new(id: json['id'], email: json['email'], token: json['tokens'])]
        end
      end # << self

      attr_reader :id, :email, :token

      def initialize(id:, email:, token:)
        @id    = id
        @email = email
        @token = token
      end

      # TODO: build_order, orders
    end # class
  end
end
