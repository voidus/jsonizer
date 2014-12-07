[![Gem Version](https://badge.fury.io/rb/jsonizer.png)](http://rubygems.org/gems/jsonizer)
[![Build Status](https://secure.travis-ci.org/voidus/jsonizer.png?branch=master)](https://travis-ci.org/voidus/jsonizer)
[![Code Climate](https://codeclimate.com/github/voidus/jsonizer.png)](https://codeclimate.com/github/voidus/jsonizer)
[![Coverage Status](https://coveralls.io/repos/voidus/jsonizer/badge.png?branch=master)](https://coveralls.io/r/voidus/jsonizer)
[![Dependencies](https://gemnasium.com/voidus/jsonizer.png)](https://gemnasium.com/voidus/jsonizer)
[![Documentation](http://inch-ci.org/github/voidus/jsonizer.svg?branch=master)](http://inch-ci.org/github/guard/guard)
[![PullReview stats](https://www.pullreview.com/github/voidus/jsonizer/badges/master.svg?)](https://www.pullreview.com/github/voidus/jsonizer/reviews/master)

[gem version]: http://badge.fury.io/rb/jsonizer
[travis]: https://travis-ci.org/voidus/jsonizer
[codeclimate]: https://codeclimate.com/github/voidus/jsonizer
[coveralls]: https://coveralls.io/r/voidus/jsonizer
[dependencies]: https://gemnasium.com/voidus/jsonizer

# Jsonizer

Module to easily provide json serialization

It was structurally inspired by http://github.com/dkubb/equalizer

## Installation

Using [Bundler](http://gembundler.com) (recommended)

  * Add `gem 'jsonizer'` to your Gemfile
  * Run `bundle install`

Using rubygems

  * Run `gem install jsonizer`

Installing from git

  * Clone the repository using `git clone git://github.com/voidus/jsonizer`
  * Enter the directory using `cd jsonizer`
  * Build and install the gem with `rake install`

## Usage

```ruby
class TransferObject
  include Jsonizer.new :operation_id, :parameter

  attr_reader :operation_id, :parameter
  attr_accessor :calculation_strategy

  def initialize operation_id, parameter, transient = "default transient attribute"
    @operation_id = operation_id
    @parameter = parameter
    @transient_attribute = transient
  end
end

TestTransferObject.new("add", [15, 20], 'transient').to_json nil
  # {"json_class":"TestTransferObject","operation_id":"add","parameter":[15,20]}

JSON.dump(TestTransferObject.new("add", [15, 20], 'transient))
  # {"json_class":"TestTransferObject","operation_id":"add","parameter":[15,20]}

JSON.load(JSON.dump(TestTransferObject.new("add", [15, 20], 'transient))).inspect
  # #<TestTransferObject:0x000000018ae188
  #   @operation_id="add",
  #   @parameter=[15, 20],
  #   @transient_attribute="default transient attribute">

JSON.dump(TestTransferObject.new("nested", TestTransferObject.new("op", "param")))
  # {"json_class":"TestTransferObject",
  #  "operation_id":"nested",
  #  "parameter":
  #     {"json_class":"TestTransferObject",
  #      "operation_id":"op",
  #      "parameter":"param"}}

JSON.load(JSON.dump(TestTransferObject.new("nested", TestTransferObject.new("op", "param"))))
  # <TestTransferObject:0x0000000268d308
  #   @operation_id="nested",
  #   @parameter=#<TestTransferObject:0x0000000268d5b0
  #                @operation_id="op",
  #                @parameter="param",
  #                @transient_attribute="default transient attribute">,
  #   @transient_attribute="default transient attribute">
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your tests and changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
