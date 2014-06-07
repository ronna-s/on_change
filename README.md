# OnChange

Subscribe to attribute changes events for your active record

## Installation

Add this line to your application's Gemfile:

    gem 'on_change'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install on_change

## Usage

```ruby

class Book < ActiveRecord::Base
  on_change :title, :lookup_in_google_books
  on_change :title, :price, do |model, attr_name, old_value,new_value|
    model.do_something
  end
  def lookup_in_google_books(attr_name, old_value, new_value)
  end
end


```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request