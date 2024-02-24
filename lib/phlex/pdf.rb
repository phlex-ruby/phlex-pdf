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
      before_template if respond_to?(:before_template)
      view_template(&block)
      after_template if respond_to?(:after_template)
    end

    def render(component, &block)
      component.call(@document, &block)
      nil
    end

    def self.document(document = Prawn::Document.new)
      new.call(document)
      document
    end
  end
end
