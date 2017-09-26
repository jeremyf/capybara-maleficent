# Capybara::Maleficent

Capybara is a fantastic testing tool. In our experience, we've encountered fragile feature specs when running headless browsers.

At it's core, `Capybara::Maleficent` exposes a method for wrapping blocks of code within sleep intervals ([see `Capybara::Maleficent.with_sleep_injection`][1]), rescuing handled exceptions and trying again. Yes, this is not ideal, as it slows down potential tests. But it is far worse (again in our experience) to have a of Capybara spec fail erratically.

This gem goes a step further, when you `require 'capybara/maleficent/spindle'`, then the node matchers will automatically make use of the `.with_sleep_injection` behavior.

The nature of `Capybara::Maleficent` is such that most of the time the matching will be as fast as they can be (they're slow enough as you are leveraging a browser for this testing). However, when a failure occurs, `Capybara::Maleficent` assumes that its due to a slowness in the browser (and not an actual failure). From there, it sleeps for a bit, then tries again.

## Using

In you Gemfile:

```ruby
gem 'capybara-maleficent', require: 'false'
```

In your `spec/spec_helper.rb`

```ruby
require 'capybara/maleficent/spindle'
```

[1]:https://github.com/jeremyf/capybara-maleficent/blob/master/lib/capybara/maleficent.rb#L16
