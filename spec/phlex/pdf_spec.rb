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
  def view_template
    render HeaderComponent.new
    render [
      WarningComponent.new("Danger!"),
      WarningComponent.new("Don't Panic!")
    ]
    render BodyComponent do |body|
      body.greet "Brad"
    end
    render FooterComponent.new
  end
end

RSpec.describe Phlex::PDF do
  it "generates a PDF" do
    PageComponent.render
  end
end
