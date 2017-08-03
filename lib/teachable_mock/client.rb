# frozen_string_literal: true

module Teachable
  module Mock
    class Client
      ACCEPT_HEADER       = 'Accept'
      APPLICATION_JSON    = 'application/json'
      CODE_200            = '200'
      CODE_422            = '422'
      CODE_401            = '401'
      CONTENT_TYPE_HEADER = 'Content-Type'

      def initialize(hostname)
        @hostname = hostname
      end

      def request(type:, path:, query: nil, payload: nil)
        uri      = build_uri(path: path, query: query)
        http     = build_http_from_uri(uri)
        response = make_request(type: type, http: http, uri: uri, payload: payload)
        return [process_errors(response.body), nil] if response.code == CODE_422 ||
                                                       response.code == CODE_401
        return [nil, nil] if type == :delete

        [nil, Yajl::Parser.parse(response.body)]
      end

      private

      attr_reader :hostname

      def build_http_class_from(scheme)
        return URI::HTTPS if https_scheme?(scheme)
        URI::HTTP
      end

      def build_request_from_type(type:, request_uri:)
        case type
        when :post
          Net::HTTP::Post.new(request_uri)
        when :get
          Net::HTTP::Get.new(request_uri)
        when :delete
          Net::HTTP::Delete.new(request_uri)
        else
          raise ArgumentError, "type #{type} not supported"
        end
      end

      def build_http_from_uri(uri)
        Net::HTTP.new(uri.host, uri.port).tap do |http|
          http.read_timeout = Mock.configuration.read_timeout
          http.open_timeout = Mock.configuration.open_timeout
          http.use_ssl      = https_scheme?(uri.scheme)
        end
      end

      def build_uri(path:, query:)
        uri = URI.parse(hostname)

        args = { host: uri.hostname, path: path }
        args[:query] = query if query

        build_http_class_from(uri.scheme).build(args)
      end

      def https_scheme?(scheme)
        scheme == 'https'
      end

      def make_request(type:, http:, uri:, payload:)
        response = nil

        http.start do |h|
          r = build_request_from_type(type: type, request_uri: uri.request_uri)
          r[CONTENT_TYPE_HEADER] = APPLICATION_JSON
          r[ACCEPT_HEADER]       = APPLICATION_JSON

          r.body = payload if payload

          response = h.request r
        end

        response
      end

      def process_errors(body)
        body = Yajl::Parser.parse(body)

        body.dig('errors') || body.dig('error')
      end
    end # class
  end
end
