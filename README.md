# Phlex::PDF

Phlex PDF lets you compose PDF files with components in pure Ruby. It's a thin layer that sits on the shoulder of giants, [Prawn](https://github.com/prawnpdf/prawn), that encourages a component-first approach to building PDF documents.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add phlex-pdf

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install phlex-pdf

## Usage

```ruby
require "phlex/pdf"

class ApplicationComponent < Phlex::PDF
  def before_template
    text "Before #{self.class.name}"
  end

  def after_template
    text "After #{self.class.name}"
  end
end

class BoxComponent < ApplicationComponent
  def view_template
    text "I'm a box"
    yield
  end
end

class NoticeComponent < ApplicationComponent
  def view_template
    text "Hello World!"

    render BoxComponent.new do
      text "Look! I'm a box inside a box!"
    end
  end
end

NoticeComponent.pdf.render_file "poof.pdf"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/phlex-ruby/phlex-pdf. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/phlex-ruby/phlex-pdf/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Phlex::PDF project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/phlex-ruby/phlex-pdf/blob/main/CODE_OF_CONDUCT.md).
