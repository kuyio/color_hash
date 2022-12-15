# ColorHash

Generate a color based on a given String, by calculating a color value from the String's hash. The result is deterministic: the same value will always result in the same color (so long as the hash function remains deterministic).

Generated colours can be useful to dynamically generate tags like these:
![demo](doc/demo.png)

## Installation

Install the gem and add to the application's Gemfile by executing:

```sh
$ bundle add color_hash
```

If bundler is not being used to manage dependencies, install the gem by executing:

```sh
$ gem install color_hash
```

## Usage

By default, `ColorHash` will generate color values in the Hue range between `[0..360]`, and with a lightness and saturation value of one of `[0.35, 0.5, 0.65]`.

```ruby
color_hash = ColorHash.new()

hex = color_hash.hex("Hello World!")
hsl = color_hash.hsl("Hello World!")
rgb = color_hash.rgb("Hello World!")
```

The resulting values are going to be:

```ruby
hex = "#d2797c"
hsl = [358, 0.5, 0.65]
rgb = [210, 121, 124]
```

You can customize the desired `hue` range(s), `saturation` and `lightness` values by passing the corresponding arguments to the constructor. For example, to generate colors in the blue spectrum:

```ruby
color_hash = ColorHash.new(hue: [{min: 180, max: 240}])
color = color_hash.hex("Hello World!")
```

will result in a `color` value of:

```ruby
color = "#79acd2"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kuyio/color_hash.

## Attribution

See https://github.com/zenozeng/color-hash for the original implementation in JavaScript.
