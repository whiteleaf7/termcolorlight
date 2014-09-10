# TermColorLight

This gem is library that convert color tags (e.g. `<red>str</red>` ) to
ansicolor(vt100 escape sequence). And this's lightweight version of
TermColor.gem without other gems. In addition process spedd is surprisingly fast.

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
require "termcolorlight"

TermColorLight.parse("<red>strings</red>")  # => \e[31mstrings\e[0m
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

## Benchmark

### Code

```ruby
require "termcolor"
require "termcolorlight"
require "benchmark"

n = 100000
Benchmark.bm(20) do |bm|
  bm.report "TermColor.parse" do
    n.times do
      TermColor.parse("<red>red</red>")
    end
  end
  bm.report "TermColorLight.parse" do
    n.times do
      TermColorLight.parse("<red>red</red>")
    end
  end
end
```

### Results

> Performed by OSX. 

Use ruby 2.0.0p451

```
                           user     system      total        real
TermColor.parse       13.770000   5.830000  19.600000 ( 19.595587)
TermColorLight.parse   2.880000   0.010000   2.890000 (  2.899383)
```

You could see that processing speed of TermColorLight is much faster
than TermColor's one.

Use ruby 2.2.0 (2014-08-20 trunk 47225 [x86_64-darwin13])

```
                           user     system      total        real
TermColor.parse       12.960000   4.720000  17.680000 ( 17.674688)
TermColorLight.parse   0.850000   0.000000   0.850000 (  0.853439)
```

Oops...

## Contributing

1. Fork it ( https://github.com/whiteleaf7/termcolorlight/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
