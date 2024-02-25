# frozen_string_literal: true

require_relative "pdf/version"
require "prawn"
require "matrix"

module Phlex
  class PDF
    class Error < StandardError; end

    include Prawn::View

    def call(document, &block)
      @document = document
      around_template do
        view_template(&block)
      end
    end

    # @abstract Override this method to hook in around a template render. You can do things before and after calling `super` to render the template. You should always call `super` so that callbacks can be added at different layers of the inheritance tree.
    # @return [nil]
    def around_template
      before_template
      yield
      after_template
      nil
    end

    # @abstract Override this method to hook in right before a template is rendered. Please remember to call `super` so that callbacks can be added at different layers of the inheritance tree.
    # @return [nil]
    def before_template
      nil
    end

    # @abstract Override this method to hook in right after a template is rendered. Please remember to call `super` so that callbacks can be added at different layers of the inheritance tree.
    # @return [nil]
    def after_template
      nil
    end

    def render(renderable, &block)
      case renderable
      when String
        @document.text renderable
      when Phlex::PDF
        renderable.call(@document, &block)
      else
        raise ArgumentError, "You can't render a #{renderable.inspect}."
      end

      nil
    end

    class << self
      def document(document = Prawn::Document.new)
        new.call(document)
        document
      end

      def render(...)
        document.render(...)
      end

      def render_file(...)
        document.render_file(...)
      end
    end
  end
end
