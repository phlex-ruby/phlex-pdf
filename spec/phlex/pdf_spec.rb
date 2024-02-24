# frozen_string_literal: true

RSpec.describe Phlex::Pdf do
  it "generates a PDF" do
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

    ApplicationComponent.document.render
  end
end
