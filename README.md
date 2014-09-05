# Termcolorlight

This gem is library that convert color tags (e.g. `<red>str</red>` ) to
ansicolor(vt100 escape sequence).

Lightweight version of TermColor.gem.
No use other gems, it is very simply.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'termcolorlight'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install termcolorlight

## Usage

```ruby
TermColor.parse("<red>strings</red>")  # => \e[31mstrings\e[0m
"<red>strings</red>".termcolor  # a ditto

str = "<div>container</div>"
"<bold><green>#{str.escape}</green></bold>"  # => \e[1m\e[32m<div>container</div>\e[0m\e[1m\e[0m
```

You can use the following tags.

```
# forground tags
black, red, green, yellow, blue, magenta, cyan, white, gray

# background tags
on_black, on_red, on_green, on_yellow, on_blue, on_magenta, on_cyan, on_white, on_gray

# decorations
bold, dark, underline, underscore, blink, reverse, concealed
```

## Contributing

1. Fork it ( https://github.com/whiteleaf7/termcolorlight/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
