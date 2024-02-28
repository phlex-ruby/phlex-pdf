# frozen_string_literal: true

require "phlex/pdf"

class PDFComponent < Phlex::PDF
end

class PDFPage < PDFComponent
  def before_template = start_new_page
end

class WarningComponent < PDFComponent
  def initialize(message)
    @message = message
  end

  def view_template
    text @message, color: "FF0000"
  end
end

class HeaderComponent < PDFComponent
  def view_template
    text "Header", size: 24
  end
end

class FooterComponent < PDFComponent
  def view_template
    text "Page #{document.page_number}"
  end
end

class BodyComponent < PDFComponent
  def view_template
    render "Body"
    yield if block_given?
  end

  def greet(name)
    text "Hello #{name}", color: "0000FF"
  end
end

class MyPage < PDFPage
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

class PDFDocument < PDFComponent
  def view_template
    render [
      MyPage.new("Hi", subtitle: "There"),
      MyPage.new("Friendly", subtitle: "Pal"),
      MyPage.new("Whats", subtitle: "Up")
    ]
  end
end

RSpec.describe Phlex::PDF do
  it "generates a PDF" do
    PDFDocument.new.to_pdf
  end
end
