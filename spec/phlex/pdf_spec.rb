# frozen_string_literal: true

require "phlex/pdf"

class ApplicationComponent < Phlex::PDF
  def before_template
    text "Before #{self.class.name}"
  end

  def view_template
    text self.class.name
  end

  def after_template
    text "After #{self.class.name}"
  end
end

class WarningComponent < ApplicationComponent
  def initialize(message)
    @message = message
  end

  def view_template
    text @message, color: "FF0000"
  end
end

class HeaderComponent < ApplicationComponent
  def view_template
    text "Header"
  end
end

class FooterComponent < ApplicationComponent
  def view_template
    text "Footer"
  end
end

class BodyComponent < ApplicationComponent
  def view_template
    render "Body"
    yield if block_given?
  end

  def greet(name)
    text "Hello #{name}", color: "0000FF"
  end
end

class PageComponent < ApplicationComponent
  def initialize(title, subtitle: )
    @title = title
    @subtitle = subtitle
  end

  def view_template
    render HeaderComponent.new

    text @title
    text @subtitle

    render [
      WarningComponent.new("Danger!"),
      WarningComponent.new("Don't Panic!")
    ]

    render Proc.new { text "Rendered from Proc.new", color: "00FF00" }
    render proc { text "Rendered from proc", color: "00FFFF" }
    render lambda { text "Rendered from lambda", color: "FFFF00" }
    render -> { text "Rendered from ->", color: "99FF00" }
    render method(:calm)

    render BodyComponent do |body|
      body.greet "Brad"
    end
    render FooterComponent.new
  end

  def calm
    text "Rendered from Method", color: "F0F0F0"
  end
end

RSpec.describe Phlex::PDF do
  it "generates a PDF" do
    PageComponent.document("Hi", subtitle: "There").render
  end
end
