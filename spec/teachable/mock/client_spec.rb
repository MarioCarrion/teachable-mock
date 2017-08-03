# frozen_string_literal: true

require 'spec_helper'

shared_examples :client_response_result do |method|
  it 'returns the response correctly' do
    error, json = subject.request(type: method, path: '/path', query: 'query=1')
    expect(error).to be_nil
    expect(json).to match('hello' => 'world')
  end
end

describe Teachable::Mock::Client, type: :model do
  describe '#request' do
    subject { described_class.new('http://stub.com') }

    context 'when type is GET' do
      before do
        stub_request(:get, 'http://stub.com/path?query=1')
          .to_return(body:    '{"hello":"world"}',
                     status:  200,
                     headers: { 'Content-Type' => 'application/json' })
      end

      it_behaves_like :client_response_result, :get
    end # when request is POST

    context 'when type is POST' do
      before do
        stub_request(:post, 'http://stub.com/path?query=1')
          .to_return(body:    '{"hello":"world"}',
                     status:  200,
                     headers: { 'Content-Type' => 'application/json' })
      end

      it_behaves_like :client_response_result, :post
    end # when request is POST

    context 'when type is not supported' do
      it 'raises the error' do
        expect {
          subject.request(type: :head, path: '/path', query: 'query=1')
        }.to raise_error('type head not supported')
      end
    end
  end
end
