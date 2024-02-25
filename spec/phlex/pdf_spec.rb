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
  end
end

class PageComponent < ApplicationComponent
  def view_template
    render HeaderComponent.new
    render BodyComponent.new do
      yield
    end
    render FooterComponent.new
  end
end

RSpec.describe Phlex::PDF do
  it "generates a PDF" do
    PageComponent.render_file "poof.pdf"
  end
end
