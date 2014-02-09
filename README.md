# JibbaJabba

JibbaJabba is a fluent Ruby wrapper for the HipChat API using familiar ActiveRecord syntax.  For example, you may chain familiar methods like `#all`, `#limit`, or `#offset` as in:
```rb
HipChat::Room.all.offset(25).limit(100)
```
to query the HipChat API at `https://api.hipchat.com/v2/room?start-index=25&max-results=100`.

![Mr. T wants you to quit yo jibbajabba](https://raw.github.com/NathanielWroblewski/jibbajabba/master/mrt.jpg)

## Installation

Add this line to your application's Gemfile:

    gem 'jibbajabba'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jibbajabba

## Usage

First, set your API key, which you can obtain [here](https://www.hipchat.com/account/api).

```rb
# set it directly using the attr_accessor
HipChat.api_key = 'MY HIPCHAT API KEY GOES HERE'

# set it by passing a block
HipChat.configure do |config|
  config.api_key = 'MY HIPCHAT API KEY GOES HERE'
end
```

Be safe with API keys.  Use environment variables or the [Figaro](https://github.com/laserlemon/figaro) gem or something.

There are two HipChat API "models" that you can query: `HipChat::Room` and `HipChat::User`.  All queries can be kicked by calling `#to_hash` or any `Hash` or `Enumerable` method on the `HipChat::Room` response object.

HipChat::Room
---
Examples:
```rb
# Note that the kicker ('#to_hash', etc.) must be called to hashify the return object or else 
# you'll get a HipChat::Room object which is probably not what you want
HipChat::Room.all
# => Returns a HipChat::Room object of all rooms for the user

HipChat::Room.all.to_hash
# => Returns a Ruby Hash of all rooms for the user

HipChat::Room.all.each{ |key, value| p "#{key}: #{value}"}
# => Returns a Ruby Hash and prints all key-value pairs

# Construct API queries using familiar ActiveRecord syntax
HipChat::Room.all.limit(100).offset(25).to_hash
# => Returns the result (as a Ruby Hash) from querying the API at
# https://api.hipchat.com/v2/room?start-index=25&max-results=100
```

Methods:
```rb
HipChat::Room.all # => all rooms for the user, default limit of 100, default start index of 0
HipChat::Room.all.limit(10) # => change the default limit
HipChat::Room.all.offset(25) # => change the start index

room = HipChat::Room.create(name: 'Boom Pop', owner_user_id: 'me@email.com', privacy: 'public', guest_access: false )
room.update_attributes(name: 'Jibba', is_archived: false, is_guest_accessible: true, topic: 'Jabba', ... )
```

## Contributing

1. Fork it ( http://github.com/NathanielWroblewski/jibbajabba/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
