# TentCanonicalJson [![Build Status](https://travis-ci.org/tent/tent-canonical-json-ruby.png)](https://travis-ci.org/tent/tent-canonical-json-ruby)

Derive Tent canonical json from post.

## Installation

Add this line to your application's Gemfile:

    gem 'tent-canonical-json'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tent-canonical-json

## Usage

```ruby
post = Hash.new # replace with hash representation of post json
TentCanonicalJson.encode(post) # => canonical json string
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
