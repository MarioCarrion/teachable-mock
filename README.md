# Teachable Mock API Wrapper

[![Build Status](https://travis-ci.org/MarioCarrion/teachable-mock.svg?branch=master)](https://travis-ci.org/MarioCarrion/teachable-mock)
[![Test Coverage](https://codeclimate.com/github/MarioCarrion/teachable-mock/badges/coverage.svg)](https://codeclimate.com/github/MarioCarrion/teachable-mock/coverage)

Ruby gem that wraps the [Teachable Mock API](https://fast-bayou-75985.herokuapp.com/)

## Development

This assumes you're using [`rvm`](https://rvm.io/)

1. `gem install bundler && bundle install`
2. `bundle exec rspec`
3. Profit

## Examples

```ruby
require 'teachable_mock'

user = Teachable::Mock::User.register(email: 'fancy@email.com',
                                      password: 'abcdef12345',
                                      password_confirmation: 'abcdef12345')

order = user.create_order('number'         => 3,
                          'total'          => 10,
                          'total_quantity' => 99)
order.delete
```
