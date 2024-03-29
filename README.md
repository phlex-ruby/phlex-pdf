# Phlex::PDF

Phlex PDF lets you compose PDF files with components in pure Ruby. It's a thin layer that sits on the shoulder of giants, [Prawn](https://github.com/prawnpdf/prawn), that encourages a component-first approach to building PDF documents.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add phlex-pdf

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install phlex-pdf

## Usage

`Phlex::PDF` is a thin wrapper around `Prawn::View`, so you'll want to become familiar with [PrawnPDF](http://prawnpdf.org/), particularly the [PrawnPDF Manual](https://prawnpdf.org/manual.pdf).

```ruby
require "phlex/pdf"

# Base component. You'll put methods here that are shared across all components.
class PDFComponent < Phlex::PDF
end

# Page has a `before_template` method that created a new page. Without a page
# nothing will render and an error would occur.
class PDFPage < PDFComponent
  # Creates a new page
  def before_template = create_new_page

  def after_template
    text "Page #{document.page_number}"
  end
end

# Example component inherits from PDFComponent. Note that it does NOT create any
# new pages.
class BoxComponent < PDFComponent
  def view_template
    text "I'm a box"
    yield
  end
end

# The final PDF that's rendered should be a subclass of PDFPage. Components
# can be rendered within a PDFPage.
class MyPage < PDFPage
  def initialize(title:)
    @title = title
  end

  def view_template
    text @title

    render BoxComponent.new do
      text "Look! I'm a box inside a box!"
    end
  end
end

# Render the PDF to a string.
MyPage.new(title: "This is a PDF!").to_pdf
```

### Rails integration

To stream PDFs from Rails controllers, the `send_pdf` helper that wraps `send_data` and renders the PDF is available.

```ruby
class MyController < ApplicationController
  include Phlex::PDF::Rails::Helpers

  def show
    send_pdf MyPage.new(title: "This is a PDF!")
  end
end
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
