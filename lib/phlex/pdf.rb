# frozen_string_literal: true

require_relative "pdf/version"
require "prawn"
require "matrix"

module Phlex
  class PDF
    include Prawn::View

    def document = @document

    def call(document, &block)
      @document = document
      around_template do
        if block_given?
          view_template do
            yield_content(&block)
          end
        else
          view_template
        end
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

    def to_pdf(...)
      self.class.blank.tap{ |doc| call doc }.render(...)
    end

    def yield_content(&block)
      return unless block_given?

      if block.arity.zero?
        # This handles lambdas and ->
        yield
      else
        # This handles Proc and proc
        yield self
      end
    end

    def render(renderable, &block)
      case renderable
      when Phlex::PDF
        renderable.call(@document, &block)
      when String
        @document.text renderable
      when Class
        render(renderable.new, &block) if renderable < Phlex::PDF
      when Proc, Method
        yield_content(&renderable)
      when Enumerable
        renderable.each { |r| render(r, &block) }
      else
        raise ArgumentError, "You can't render a #{renderable.inspect}."
      end

      nil
    end

    class << self
      # Components should override this method to define their view.
      def blank = Prawn::Document.new(skip_page_creation: true)
    end
  end
end
